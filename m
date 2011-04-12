Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751392Ab1DLEKt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 00:10:49 -0400
Received: from smtp10.mail.ru ([94.100.176.152]:43269 "EHLO smtp10.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1749667Ab1DLEKs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 00:10:48 -0400
Date: Tue, 12 Apr 2011 08:10:45 +0400
From: Dmitry Artamonow <mad_soft@inbox.ru>
To: Keshava Munegowda <keshava_mgowda@ti.com>
Cc: Steve Sakoman <sakoman@gmail.com>, Steve Calfee <stevecalfee@gmail.com>,
        Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Regression?] Removed regulator support in ehci-omap
Message-ID: <20110412040420.GB25239@rainbow>
References: <20110411093214.GA18215@rainbow>
 <4DA3350E.2060400@gmail.com>
 <BANLkTinDMZ+CyGCmzZu8cSz1L_yFXxm+vg@mail.gmail.com>
 <112ef82aebc719ef25cde126f2014ebc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <112ef82aebc719ef25cde126f2014ebc@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02:18 Tue 12 Apr     , Keshava Munegowda wrote:
> 
> Sorry guys! I will work on it coming week; currently I am in travel.
> 
> Well, regulator is not removed, its moved to usbhs core driver in
> /driver/mfd/omap xx usb xxx host.c

Ah, so EHCI/OHCI common code was moved into drivers/mfd... Good.
But seems regulators support was lost somewhere during transition - the
only mentioning about regulators in omap-usb-host.c is "#include" :

mad@macmini:~/kernel-hack/linux-2.6(master)$ grep -i regulator drivers/mfd/omap-usb-host.c
#include <linux/regulator/consumer.h>
mad@macmini:~/kernel-hack/linux-2.6(master)$ 

-- 
Best regards,
Dmitry "MAD" Artamonow

