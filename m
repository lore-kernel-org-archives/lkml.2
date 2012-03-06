Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758584Ab2CFIHd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 03:07:33 -0500
Received: from ud10.udmedia.de ([194.117.254.50]:40275 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758388Ab2CFIHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 03:07:31 -0500
Date: Tue, 6 Mar 2012 09:07:27 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Neal Cardwell <ncardwell@google.com>
Cc: Christian Kujau <lists@nerdbynature.de>, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: WARNING: at net/ipv4/tcp_input.c:3418
Message-ID: <20120306080727.GA1641@x4>
References: <alpine.DEB.2.01.1202261556150.4930@trent.utfs.org>
 <alpine.DEB.2.01.1202290929520.4930@trent.utfs.org>
 <CADVnQy=JkVc_8ptpSkhQWe4HJpbe_+JMad+2uqgN1iUfkfFFCw@mail.gmail.com>
 <CADVnQykqaUCFBYXVqGNq+HmeowAbYJQQNpbXFpQ4Uif3gwf4ig@mail.gmail.com>
 <CADVnQyk_6LYW2nyjccWjv1NmjivXf5cXBqJ+LsZLjGyOj7kddQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADVnQyk_6LYW2nyjccWjv1NmjivXf5cXBqJ+LsZLjGyOj7kddQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012.03.06 at 00:46 -0500, Neal Cardwell wrote:
> On Wed, Feb 29, 2012 at 12:41 PM, Christian Kujau <lists@nerdbynature.de> wrote:
> > This is still happening with 3.3.0-rc5, .config & dmesg here:
> >
> >   http://nerdbynature.de/bits/3.3.0-rc4/ipv4/
> 
> I was finally able to reproduce this issue where there are warnings
> about sacked_out going negative (since 3.3.0-rc4), and my testing
> shows that this patch seems to fix the issue:
> 
>   http://patchwork.ozlabs.org/patch/144844/
> 
> For folks who were seeing this problem and are so inclined, feel free
> to try the latest 3.3-rc6 kernel (or davem's "net" tree in git, if
> that's easier) with that patch applied, and let me know how it goes.

Thanks for tracking this down, Neal.

In my case it looks like the issue was an "once in a lifetime" event.
So no amount of testing would prove anything.

-- 
Markus
