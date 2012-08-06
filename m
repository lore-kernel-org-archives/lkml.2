Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798Ab2HFWhP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 18:37:15 -0400
Received: from oproxy11-pub.bluehost.com ([173.254.64.10]:47739 "HELO
	oproxy11-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756523Ab2HFWhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 18:37:13 -0400
X-Greylist: delayed 3053 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Aug 2012 18:37:13 EDT
Message-ID: <501F1278.80202@xenotime.net>
Date: Sun, 05 Aug 2012 17:40:24 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Christopher Sacchi <chris.sacchi@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: PROBLEM: New Kernel Patch
References: <CAGh4K3Kte3AK6tLWU3C63igRimuy_q8avF-Uh=2+eCfsviSEdw@mail.gmail.com>
In-Reply-To: <CAGh4K3Kte3AK6tLWU3C63igRimuy_q8avF-Uh=2+eCfsviSEdw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2012 05:27 PM, Christopher Sacchi wrote:

> Here is a new patch that should be tested that fixes a function issue
> in the description for the Mac80211 driver in tar.bz2 format.
> Let me know if it works.


No, it doesn't work.  There is no patch there.

Don't send patches in tar files.  Don't send zipped patches.
Just send plain text, inline in the body of the email.

mac80211 patches should be sent to the linux-wireless@vger.kernel.org
mailing list.

Please read Documentation/SubmittingPatches in the kernel source tree.

-- 
~Randy
