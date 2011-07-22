Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828Ab1GVW0Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 18:26:25 -0400
Received: from mail.mnsspb.ru ([84.204.75.2]:39292 "EHLO mail.mnsspb.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750916Ab1GVW0Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 18:26:24 -0400
Date: Sat, 23 Jul 2011 02:25:20 +0400
From: Kirill Smelkov <kirr@mns.spb.ru>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-uvc-devel@lists.berlios.de, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RESEND] uvcvideo: Add FIX_BANDWIDTH quirk to HP Webcam
	found on HP Mini 5103 netbook
Message-ID: <20110722222520.GA14917@tugrik.mns.mnsspb.ru>
References: <20110722144722.GA3717@tugrik.mns.mnsspb.ru> <201107230003.59800.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201107230003.59800.laurent.pinchart@ideasonboard.com>
Organization: Marine Bridge & Navigation Systems
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent, All,

On Sat, Jul 23, 2011 at 12:03:57AM +0200, Laurent Pinchart wrote:
> Hi Kirill,
> 
> On Friday 22 July 2011 16:47:22 Kirill Smelkov wrote:
> >  [ Cc'ing Andrew Morton -- Andrew, could you please pick this patch, in
> >    case there is no response from maintainers again? Thanks beforehand. ]
> > 
> > 
> > Hello up there,
> > 
> > My first posting was 1 month ago, and a reminder ~ 2 weeks ago. All
> > without a reply. v3.0 is out and they say the merge window will be
> > shorter this time, so in oder not to miss it, I've decided to resend my
> > patch on lowering USB periodic bandwidth allocation topic.
> 
> I'm very very sorry for missing the patch (and worse, twice :-/).

Nevermind. I'm curious though, whether I did something wrong or anything
else?  I mean how to avoid such long delays next time?


> > Could this simple patch be please applied?
> 
> Yes it can. I see that Andrew already applied it to his tree. Mauro, should it 
> go through there, or through your tree ? I've pushed it to my tree at 
> git://linuxtv.org/pinchartl/uvcvideo.git uvcvideo-stable, so you can already 
> pull.

You've applied the patch from my first posting, but actually in the
RESEND one I've added reference to EHCI-tweaking patch -- it is already
merged into Greg's USB tree (it was not when I first posted), so could you
please reapply? (sorry for confusion).


Thanks for replying and for uvcvideo,
Kirill
