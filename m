Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932150Ab2HPNFN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 09:05:13 -0400
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:39607 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756178Ab2HPNFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 09:05:09 -0400
MIME-Version: 1.0
In-Reply-To: <1345060759-18091-3-git-send-email-bigeasy@linutronix.de>
References: <1345060759-18091-1-git-send-email-bigeasy@linutronix.de>
	<1345060759-18091-3-git-send-email-bigeasy@linutronix.de>
Date: Thu, 16 Aug 2012 18:35:07 +0530
Message-ID: <CAAe_U6KyAt8KuzOR0dpPmN0NFDLUupzCmdfB=d5ibbN_m4nFTA@mail.gmail.com>
Subject: Re: [PATCH 2/9] scripts/modpost: add a exception for USB gadget drivers
From: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sebastian,

On Thu, Aug 16, 2012 at 1:29 AM, Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
> The "driver" struct for a gadget driver is named *_driver. On module
> load, the gadget expects a UDC driver to be loaded and avaiable. If this
> is not the case => -ENODEV and bye bye. That means that the gadget
Will this be taken care of in your future series (with configfs?).
There might be cases when your gadget driver gets loaded before the
UDC driver.

Thanks
Kishon
