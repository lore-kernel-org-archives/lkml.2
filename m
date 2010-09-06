Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab0IFSoc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 14:44:32 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54746 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752987Ab0IFSo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 14:44:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "M. Vefa Bicakci" <bicave@superonline.com>
Subject: Re: Important news regarding the two different patches
Date: Mon, 6 Sep 2010 20:43:37 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc3-rjw+; KDE/4.4.4; x86_64; ; )
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-pm@lists.linux-foundation.org,
        Minchan Kim <minchan.kim@gmail.com>
References: <20100903105216.B65C.A69D9226@jp.fujitsu.com> <20100906090528.C8A9.A69D9226@jp.fujitsu.com> <4C84D02A.7070508@superonline.com>
In-Reply-To: <4C84D02A.7070508@superonline.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009062043.37819.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, September 06, 2010, M. Vefa Bicakci wrote:
> On 05/09/10 10:08 PM, KOSAKI Motohiro wrote:
> >>> ok, thanks. probably I've catched your point. please feel free to use my reviewed-by
> >>> for your fix.
> >>
> >> Thanks.
> >>
> >> In the meantime, though, I prepared a patch that should address the issue
> >> entirely.  The patch is appended and if it looks good to you, I'd rather use it
> >> instead of the previous one (it is still untested).
> > 
> > Yeah, this one looks nicer to me :)
> > 
> > Thanks, rafael!
> 
> Dear Rafael Wysocki, Kosaki Motohiro and Minchan Kim,
> 
> Upon Kosaki Motohiro's kind request via an off-list e-mail,
> I tested the following two patches separately with a vanilla
> 2.6.35.4 kernel:
> 
> Patch 1:
> 	http://lkml.org/lkml/2010/9/5/86
> 
> Patch 2:
> 	http://kerneltrap.org/mailarchive/linux-kernel/2010/9/4/4615426
> 
> The first of these was prepared by Minchan Kim, and it fixes
> the issue; i.e. no hangs during hibernation with a full tmpfs.

We've already agreed that this patch should be applied.

> However, the second patch, prepared by Rafael Wysocki, does *not*
> fix the problem. I still experience hangs with a full tmpfs upon
> hibernation.

So we still manage to trigger OOM with this approach.

> As always, I am willing to test newer patches and help in debugging
> this issue.

What happens if you apply them both at the same time?

Thanks,
Rafael
