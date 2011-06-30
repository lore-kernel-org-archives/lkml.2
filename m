Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227Ab1F3FlL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 01:41:11 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:12127 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503Ab1F3FlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 01:41:08 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6392"; a="101008855"
From: "Tanya Brokhman" <tlinder@codeaurora.org>
To: "'Greg KH'" <greg@kroah.com>
Cc: <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, <ablay@codeaurora.org>,
        "'open list'" <linux-kernel@vger.kernel.org>
References: <1309350899-23868-1-git-send-email-tlinder@codeaurora.org> <1309350899-23868-2-git-send-email-tlinder@codeaurora.org> <20110629123826.GQ2760@legolas.emea.dhcp.ti.com> <051801cc365a$73187140$594953c0$@org> <20110629124822.GS2760@legolas.emea.dhcp.ti.com> <055801cc3681$d080ba00$71822e00$@org> <20110629194126.GA6057@legolas.emea.dhcp.ti.com> <05b101cc36e4$9067d8f0$b1378ad0$@org> <20110630052156.GA24087@kroah.com>
In-Reply-To: <20110630052156.GA24087@kroah.com>
Subject: RE: [PATCH v2 1/2] usb: gadget: add max_speed to usb_composite_driver
Date: Thu, 30 Jun 2011 08:41:03 +0300
Message-ID: <05b801cc36e8$4ec52fc0$ec4f8f40$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Acw25a8ZE4QSKoWRSjqqXsQExq4+vgAAnT0Q
Content-Language: he
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >
> > Just emailed you the fixing patch.
> > Just one thing. Greg already merged the patch that caused the
> compilation
> > warning into his tree so perhaps you can't merge the fix into the
> original
> > patch and need to post the fix as a different patch....
> 
> Nope, you can't, I need just a single patch that resolves this.  I'll
> queue up the patch you just sent, thanks.
> 

One sec! I just found out that I was running checkpatch.pl from a wrong
location. There is a checkpatch warning. I'll send you the fix in a few
minutes.
Sorry.


Thanks,
Tanya Brokhman
---
Sent by an consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.




