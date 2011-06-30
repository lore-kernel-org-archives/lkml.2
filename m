Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631Ab1F3FO0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 01:14:26 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:48757 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888Ab1F3FOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 01:14:19 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6392"; a="100796160"
From: "Tanya Brokhman" <tlinder@codeaurora.org>
To: <balbi@ti.com>
Cc: <greg@kroah.com>, <linux-usb@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, <ablay@codeaurora.org>,
        "'open list'" <linux-kernel@vger.kernel.org>
References: <1309350899-23868-1-git-send-email-tlinder@codeaurora.org> <1309350899-23868-2-git-send-email-tlinder@codeaurora.org> <20110629123826.GQ2760@legolas.emea.dhcp.ti.com> <051801cc365a$73187140$594953c0$@org> <20110629124822.GS2760@legolas.emea.dhcp.ti.com> <055801cc3681$d080ba00$71822e00$@org> <20110629194126.GA6057@legolas.emea.dhcp.ti.com>
In-Reply-To: <20110629194126.GA6057@legolas.emea.dhcp.ti.com>
Subject: RE: [PATCH v2 1/2] usb: gadget: add max_speed to usb_composite_driver
Date: Thu, 30 Jun 2011 08:14:15 +0300
Message-ID: <05b101cc36e4$9067d8f0$b1378ad0$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Acw2lI1DYw70QmeYTwWsgrSfn2Z0NAAT5yYA
Content-Language: he
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good morning Felipe,

> > I went over the emails and all is ok. Thanks!
> > One question: Greg/Alan mentioned that the compilation warning should
> > be fixed by __maybe_unused. I wasn't aware such thing existed. Just
> > looked it up.
> > Do you want me to send you a patch that fixes that or have you done
> it
> > already and I missed it again :) ?
> 
> Oops, I didn't. You can send a differential patch (just this change in
> particular) and I'll merge into the original.

Just emailed you the fixing patch.
Just one thing. Greg already merged the patch that caused the compilation
warning into his tree so perhaps you can't merge the fix into the original
patch and need to post the fix as a different patch....


Thanks,
Tanya Brokhman
---
Sent by an consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.




