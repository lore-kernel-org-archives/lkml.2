Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758054Ab1FGTJ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 15:09:27 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:22676 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754303Ab1FGTJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 15:09:25 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6370"; a="96018881"
From: "Tanya Brokhman" <tlinder@codeaurora.org>
To: <balbi@ti.com>
Cc: "'Alan Stern'" <stern@rowland.harvard.edu>, <greg@kroah.com>,
        <linux-usb@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        <ablay@codeaurora.org>, "'open list'" <linux-kernel@vger.kernel.org>
References: <016d01cc2541$0bfa5980$23ef0c80$@org> <Pine.LNX.4.44L0.1106071436020.1972-100000@iolanthe.rowland.org> <018a01cc2543$7273a5c0$575af140$@org> <20110607185415.GD12242@legolas.emea.dhcp.ti.com>
In-Reply-To: <20110607185415.GD12242@legolas.emea.dhcp.ti.com>
Subject: RE: [PATCH v15 10/10] usb:dummy_hcd: Force FS device connection according to module parameter
Date: Tue, 7 Jun 2011 22:09:01 +0300
Message-ID: <019601cc2546$6359cdf0$2a0d69d0$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
thread-index: AcwlRFPAZAen1kfeTWqizHkpUHprQgAAZwVQ
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Ok, I'll take that into consideration. Since I'm new here I was
> > "afraid" to add any changes that are not really required :)
> 
> just remember to put unrelated changes on separate patches ;-)

Yes, already learned that lesson :)

> > >
> >
> > Ok, agreed. I'll update the patch.
> 
> Cool, I'll wait for a revised series.
> 

Actually, the only patch that will be updated is this one and it's not
really related to the SS support patches, it's just based on them.
I'm telling you this because unfortunately I won't be able to post new
version until Thursday...


Thanks,
Tanya Brokhman
---
Sent by an consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.




