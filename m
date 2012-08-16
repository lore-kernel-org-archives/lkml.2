Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201Ab2HPO01 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 10:26:27 -0400
Received: from na3sys009aog127.obsmtp.com ([74.125.149.107]:50790 "EHLO
	na3sys009aog127.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752917Ab2HPO0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 10:26:22 -0400
MIME-Version: 1.0
In-Reply-To: <20120816130344.GD26408@arwen.pp.htv.fi>
References: <1345060759-18091-1-git-send-email-bigeasy@linutronix.de>
	<1345060759-18091-3-git-send-email-bigeasy@linutronix.de>
	<CAAe_U6KyAt8KuzOR0dpPmN0NFDLUupzCmdfB=d5ibbN_m4nFTA@mail.gmail.com>
	<20120816130344.GD26408@arwen.pp.htv.fi>
Date: Thu, 16 Aug 2012 19:56:19 +0530
Message-ID: <CAAe_U6LEs3W7PoTmRrD9nEdjB=0RvGpXaw5MffbeL-yS52EdEQ@mail.gmail.com>
Subject: Re: [PATCH 2/9] scripts/modpost: add a exception for USB gadget drivers
From: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
To: balbi@ti.com
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2012 at 6:33 PM, Felipe Balbi <balbi@ti.com> wrote:
> On Thu, Aug 16, 2012 at 06:35:07PM +0530, ABRAHAM, KISHON VIJAY wrote:
>> Hi Sebastian,
>>
>> On Thu, Aug 16, 2012 at 1:29 AM, Sebastian Andrzej Siewior
>> <bigeasy@linutronix.de> wrote:
>> > The "driver" struct for a gadget driver is named *_driver. On module
>> > load, the gadget expects a UDC driver to be loaded and avaiable. If this
>> > is not the case => -ENODEV and bye bye. That means that the gadget
>> Will this be taken care of in your future series (with configfs?).
>> There might be cases when your gadget driver gets loaded before the
>> UDC driver.
>
> with configfs that won't be a problem because even though function
> drivers are loaded, they won't bind to any controller until we tell them
> to through configfs. IOW, functions will only bind to UDCs after we
> assign them to a particular usb interface through configfs.

Ok. Makes sense..

Thanks
Kishon
