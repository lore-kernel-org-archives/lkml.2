Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996Ab0FGEy3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 00:54:29 -0400
Received: from tango.tkos.co.il ([62.219.50.35]:51826 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292Ab0FGEy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 00:54:28 -0400
Date: Mon, 7 Jun 2010 07:53:59 +0300
From: Baruch Siach <baruch@tkos.co.il>
To: Wan ZongShun <mcuos.com@gmail.com>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
       Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: [rtc-linux] [PATCH] rtc: driver for the DryIce block found in
 i.MX25 chips
Message-ID: <20100607045359.GE14583@jasper.tkos.co.il>
References: <0173f18c60cb4d1f8a0d123da6cd3cfca0224788.1275456869.git.baruch@tkos.co.il>
 <AANLkTimzq5zBEqrxzkm_D7trn7ikJX8yqny_6SogdIO6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimzq5zBEqrxzkm_D7trn7ikJX8yqny_6SogdIO6@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wan,

On Sat, Jun 05, 2010 at 11:08:46PM +0800, Wan ZongShun wrote:
> Some minor comments below:

Thank you very much for you review and comments. I'll address your comments 
(and Andrew's), and send an update shortly.

> Are local_irq_disable() and al_irq_enable() necessary?
> 
> RTC ‘rtc_update_irq’ seem to have called 'spin_lock_irqsave' , where
> local irq will be disable.

You're right. Since commit e6229bec25be4ba00f31dd26e25721cc96c22262 
rtc_update_irq can be called with irqs enabled.

baruch

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
