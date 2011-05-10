Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893Ab1EJNTv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 09:19:51 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:19070 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754118Ab1EJNTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 09:19:50 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+loKxAL+H1JmjGQRGLn4Xf
Date: Tue, 10 May 2011 16:19:45 +0300
From: Tony Lindgren <tony@atomide.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-omap@vger.kernel.org, David Cohen <dacohen@gmail.com>,
        Hiroshi DOYU <Hiroshi.DOYU@nokia.com>, linux-kernel@vger.kernel.org
Subject: Re: [URGENT - PATCH FOR 2.6.39] omap: iommu: Return IRQ_HANDLED in
 fault handler when no fault occured
Message-ID: <20110510131944.GH30958@atomide.com>
References: <1303912982-10309-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <201104291203.11174.laurent.pinchart@ideasonboard.com>
 <201105101439.56757.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201105101439.56757.laurent.pinchart@ideasonboard.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Laurent Pinchart <laurent.pinchart@ideasonboard.com> [110510 15:35]:
> Hi Tony,
> 
> On Friday 29 April 2011 12:03:10 Laurent Pinchart wrote:
> > Hi Tony,
> > 
> > On Wednesday 27 April 2011 16:03:02 Laurent Pinchart wrote:
> > > The iommu shares an interrupt line with the OMAP3 ISP. The iommu
> > > interrupt handler must check the fault status and return IRQ_HANDLED
> > > when no fault occured.

Can you please update the description to say something like:

Commit d594f1f31afe13edd8c02f3854a65cc58cfb3b74 (Title of the commit
here) broke XYZ and because of this so and so happens.

Then please repost the patch with linux-arm-kernel mailing list Cc'd.
 
> > > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > 
> > Could you please pick this one up for 2.6.39 ? As far as I know David is on
> > holidays so he might not be able to review the patch before the 2.6.39
> > release.
> 
> Ping. Please.

Well at least we now have something close to an ack from Hiroshi..
We really want to have acks for fixes like this, otherwise I don't
feel comfortable to rush something like this in.

Regards,

Tony
