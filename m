Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757098Ab1FGSsV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 14:48:21 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:41897 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754650Ab1FGSsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 14:48:19 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6370"; a="96013411"
From: "Tanya Brokhman" <tlinder@codeaurora.org>
To: "'Alan Stern'" <stern@rowland.harvard.edu>
Cc: <greg@kroah.com>, <linux-usb@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, <balbi@ti.com>,
        <ablay@codeaurora.org>, "'open list'" <linux-kernel@vger.kernel.org>
References: <016d01cc2541$0bfa5980$23ef0c80$@org> <Pine.LNX.4.44L0.1106071436020.1972-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1106071436020.1972-100000@iolanthe.rowland.org>
Subject: RE: [PATCH v15 10/10] usb:dummy_hcd: Force FS device connection according to module parameter
Date: Tue, 7 Jun 2011 21:47:59 +0300
Message-ID: <018a01cc2543$7273a5c0$575af140$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
thread-index: AcwlQoz3SrQGk3XiTQuUhRt6pW2zFgAAJlOA
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I'm not talking about dummy_hcd. It was a general comment about the
> gadget
> > code. I can't give you an example from the top of my head...
> 
> Oh.  Well, if you're writing new code and you come across a place where
> an error message really is needed, you should add the error message.

Ok, I'll take that into consideration. Since I'm new here I was "afraid" to
add any changes that are not really required :)

 
> But if the parameters are contradictory, you don't know _how_ to fix
> it.  If is_super_speed is True and is_high_speed is False, did the user
> want to add SuperSpeed support or to remove high-speed support?
> 
> Besides, the best (i.e., easiest and most likely to be correct) way of
> fixing the error is for the user to issue the modprobe command again,
> with the correct parameters this time.  Therefore the driver should
> fail to load, so that the modprobe can be reissued with no need to do
> rmmod first.
> 

Ok, agreed. I'll update the patch.


Thanks,
Tanya Brokhman
---
Sent by an consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.




