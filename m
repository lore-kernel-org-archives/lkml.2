Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958Ab1FGEzY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 00:55:24 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:40020 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988Ab1FGEzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 00:55:22 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6369"; a="95852648"
From: "Tanya Brokhman" <tlinder@codeaurora.org>
To: "'Alan Stern'" <stern@rowland.harvard.edu>
Cc: <greg@kroah.com>, <linux-usb@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, <balbi@ti.com>,
        <ablay@codeaurora.org>, "'open list'" <linux-kernel@vger.kernel.org>
References: <1307360469-29120-10-git-send-email-tlinder@codeaurora.org> <Pine.LNX.4.44L0.1106061138060.1953-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1106061138060.1953-100000@iolanthe.rowland.org>
Subject: RE: [PATCH v15 10/10] usb:dummy_hcd: Force FS device connection according to module parameter
Date: Tue, 7 Jun 2011 07:55:14 +0300
Message-ID: <014201cc24cf$1b3414d0$519c3e70$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
thread-index: AcwkX9kd1M8KIopuS8C+SDnBSCoHzwAbizyw
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> You might want to print out some kind of error message if the user
> specifies is_super_speed = True and is_high_speed = False.
> 

I thought about that as well. Even added it but removed at the last minute
:) I encountered quite a few places in the code where some error message to
the user is really needed but is missing so my impression was that it's best
to keep the printks to a minimum. Isn't that the general approach? IMO, in
this particular case informing the user isn't a "must". If you feel strongly
about it I can add the message.

Thanks,
Tanya Brokhman
---
Sent by an consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.




