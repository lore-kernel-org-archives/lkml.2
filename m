Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932448Ab2K1PWg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 10:22:36 -0500
Received: from DMZ-MAILSEC-SCANNER-3.MIT.EDU ([18.9.25.14]:53533 "EHLO
	dmz-mailsec-scanner-3.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754935Ab2K1PWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 10:22:35 -0500
X-Greylist: delayed 300 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Nov 2012 10:22:34 EST
X-AuditID: 1209190e-b7fd76d000005253-70-50b62b0c529b
Date: Wed, 28 Nov 2012 10:17:28 -0500 (EST)
From: Anders Kaseorg <andersk@MIT.EDU>
To: Tejun Heo <tj@kernel.org>, Herbert Xu <herbert@gondor.hengli.com.au>,
        "John W. Linville" <linville@tuxdriver.com>
cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Wireless regression in workqueue: use mod_delayed_work() instead
 of __cancel + queue
In-Reply-To: <alpine.DEB.2.00.1211280953350.26602@dr-wily.mit.edu>
Message-ID: <alpine.DEB.2.00.1211281016320.26602@dr-wily.mit.edu>
References: <alpine.DEB.2.00.1211280953350.26602@dr-wily.mit.edu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBIsWRmVeSWpSXmKPExsUixG6nosujvS3A4PN3dot9G3ktLu+aw2bx
	ZsUddoutPRIWxxaIWfxafpTRgc3j23tZj02rOtk8rnxfzejxeZNcAEsUl01Kak5mWWqRvl0C
	V8a8fzPYCiawVXQv5W5g/MPSxcjJISFgIrHmWSMThC0mceHeerYuRi4OIYF9jBLzp89hhHA2
	MEr0nIBx9jBJ7F+9hRmkhUVAW2J+dzM7iM0moCYxd8NkIJuDQ0SgTqJxfghImFkgUaJt3kRW
	EFtYIFmipfMCWDmngJPEki/b2UBsXgFHiZ7bx8AuEgKy914+B3aRqICuxN5DZ9ghagQlTs58
	wgIxU0ti+fRtLBMYBWYhSc1CklrAyLSKUTYlt0o3NzEzpzg1Wbc4OTEvL7VI11gvN7NELzWl
	dBMjKIA5Jfl2MH49qHSIUYCDUYmH96H51gAh1sSy4srcQ4ySHExKorzZmtsChPiS8lMqMxKL
	M+KLSnNSiw8xSnAwK4nwMj8CKudNSaysSi3Kh0lJc7AoifNeSbnpLySQnliSmp2aWpBaBJOV
	4eBQkuB9BjJUsCg1PbUiLTOnBCHNxMEJMpwHaPgDkBre4oLE3OLMdIj8KUZFKXHe7yAJAZBE
	RmkeXC8swbxiFAd6RZj3PEgVDzA5wXW/AhrMBDQ46CzI1cUliQgpqQbGksZvIt+Kq/Y8YZNc
	cX29rm/fWeMvx5j9VBluuMe8kFdZ0S4r/Udz+UXjN+sXTrHKqCxJW+cYeHDBcqGso50/5HoU
	eD5ld93uex++IXTjsxnszwJ7f7zx0jQ68UBm0tMZrCwef2YXdC+M33rc3+rG5OUdkrI715zm
	8FGR5p82ry1ya4LtzwsSSizFGYmGWsxFxYkASLHgvQsDAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Nov 2012, Anders Kaseorg wrote:
> My Intel 6250 wireless card (iwldvm) can no longer associate with a 
> WPA-Enterprise network (PEAP-MSCHAPv2).  To my surprise, I bisected this 
> regression to commit e7c2f967445dd2041f0f8e3179cca22bb8bb7f79, 
> workqueue: use mod_delayed_work() instead of __cancel + queue.
> 
> A bunch of logs collected by Ubuntu apport are in this bug report: 
>   https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1083980
> 
> How can I help to debug this?
> 
> I see that someone else reported another regression with the same commit 
> last week, although this looks unrelated at first glance: 
>   http://thread.gmane.org/gmane.linux.kernel/1395938
> 
> Anders

(Oops, re-sending to fix a typo in the LKML address.)

Anders
