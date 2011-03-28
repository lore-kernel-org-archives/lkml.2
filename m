Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977Ab1C1JOq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 05:14:46 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:31889 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab1C1JOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 05:14:45 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6298"; a="82417215"
From: "Tanya Brokhman" <tlinder@codeaurora.org>
To: <balbi@ti.com>
Cc: <gregkh@suse.de>, <linux-arm-msm@vger.kernel.org>, <ablay@codeaurora.org>,
        "'open list:USB GADGET/PERIPH...'" <linux-usb@vger.kernel.org>,
        "'open list'" <linux-kernel@vger.kernel.org>
References: <1300867498-20997-1-git-send-email-tlinder@codeaurora.org> <20110325134101.GM2609@legolas.emea.dhcp.ti.com> <000501cbed24$8efd1f70$acf75e50$@org> <20110328085412.GJ2251@legolas.emea.dhcp.ti.com>
In-Reply-To: <20110328085412.GJ2251@legolas.emea.dhcp.ti.com>
Subject: RE: [PATCH 5/5 v5] usb:gadget: Add SuperSpeed support to the Gadget Framework
Date: Mon, 28 Mar 2011 11:15:26 +0200
Message-ID: <000601cbed28$aee4dc20$0cae9460$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcvtJbBxD0IiRZLpQGOXSycw6RyFjAAAi96g
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi
 
> > I believe that in the future all gadget drivers will define their own
> SS
> > descriptors with values that are suitable for that gadget driver and
> the
> > create_ss_descriptors() will become obsolete. As I've already
> mentioned this
> > is just a way to allow all the existing drivers to operate in SS mode
> with
> > minimum changes to their code. So this patch doesn't contradict your
> > approach, just extends it.
> 
> but that's not a good approach. You're adding bloat which will be
> removed soon. Problem is that once it's there, we will have to support
> it for a long long time as we won't know if there are any out of tree
> gadget drivers depending on that, forcing us on publising of
> Documentation/feature-removal-schedule.txt that we will remove that
> layer in e.g. 4 major revisions. So, IMHO, better not to add it.
> 

I see your point. I'll generate a different patch for this function
(create_ss_descriptors()) so it will be easy to take it out of the patch
series if we eventually decide against it. I think it's still useful to have
this ability since it can help developers at the beginning even if not
adding it to the formal kernel release and just have it in the mailing list
archives.

Best regards,
Tanya Brokhman
Consultant for Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum





