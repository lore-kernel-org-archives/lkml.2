Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308Ab1EXFgB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 01:36:01 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:37764 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab1EXFgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 01:36:00 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6355"; a="93188692"
From: "Tanya Brokhman" <tlinder@codeaurora.org>
To: "'Mike Frysinger'" <vapier@gentoo.org>
Cc: "'Sebastian Andrzej Siewior'" <bigeasy@linutronix.de>, <greg@kroah.com>,
        <linux-usb@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        <balbi@ti.com>, <ablay@codeaurora.org>,
        "'open list'" <linux-kernel@vger.kernel.org>
References: <1306132882-9668-1-git-send-email-tlinder@codeaurora.org> <1306132882-9668-5-git-send-email-tlinder@codeaurora.org> <20110523123135.GA10785@linutronix.de> <00eb01cc19d0$e526a9b0$af73fd10$@org> <BANLkTikB+9koYz6Gv4sZEhfn9kts66Rs_g@mail.gmail.com>
In-Reply-To: <BANLkTikB+9koYz6Gv4sZEhfn9kts66Rs_g@mail.gmail.com>
Subject: RE: [PATCH v12 4/8] usb:gadget: Add SuperSpeed support to the Gadget Framework
Date: Tue, 24 May 2011 08:37:43 +0300
Message-ID: <00ec01cc19d4$b6c75660$24560320$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcwZ0Xui1JKffxTZQW+Hu0eOq9IPQAAAvx/Q
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >
> > Mike answered that you're right in your observation. I'm not familiar
> with
> > blackfin. Could you please elaborate on this? I understand that I
> need to
> > use put_unaligned_le16(), will do, but I would like to better
> understand why
> > and if there is a way to test this so that blackfin won't be broken.
> 
> not all arches support unaligned accesses.  or they do, but it's done
> via (non-trivial) exception processing in software.  req->buf is of
> type void* and so presumably is not guaranteed to be aligned on a 2
> byte boundary.
> -mike

Thanks for the explanation, Mike! I'll update the patch.

Best regards,
Tanya Brokhman
Consultant for Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum




