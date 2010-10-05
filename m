Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757833Ab0JEHwl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 03:52:41 -0400
Received: from senator.holtmann.net ([87.106.208.187]:36027 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755360Ab0JEHwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 03:52:40 -0400
Subject: Re: [PATCH] Added firmware load patch to crap directory. This
 patch loads firmware from btusb when device is plugged in.
From: Marcel Holtmann <marcel@holtmann.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Bala Shanmugam <sbalashanmugam@atheros.com>,
        linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTinjiJ6FyoAi4aP=8pr9EwV0wpV7LtwQx-hwaOFs@mail.gmail.com>
References: <1285931572-3592-1-git-send-email-sbalashanmugam@atheros.com>
	 <AANLkTinjiJ6FyoAi4aP=8pr9EwV0wpV7LtwQx-hwaOFs@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Oct 2010 09:52:35 +0200
Message-ID: <1286265155.17473.25.camel@aeonflux>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Luis,

> > Marcel feels that Atheros sflash based BT device
> > +doesn't follow bluetooth H:2 specification and HCI commands should be supported
> > +in firmware if it is detected as bluetooth device. Using HCI command, firmware
> > +should be loaded.
> > +
> > +In sfash based device we don't have enough memory to support HCI commands in firmware.
> > +So load firmware from btusb when the device comes up.
> > +
> 
> You should still ask the maintainer for an alternative, otherwise the
> device unusable. Did you submit the patch first in [PATCH] form? If
> not please submit the patch, all I saw as an RFC and no followup at
> all.

I think it is pretty clear how these devices should be designed when it
comes to firmware loading. Just having different USB PIDs for firmware
loading stage and fully functional Bluetooth device stage is not that
hard to do. Other companies have done this.

If you device claims Bluetooth USB class descriptors, then it should
behave like that and offer HCI protocol running on it.

Regards

Marcel


