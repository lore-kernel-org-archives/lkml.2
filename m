Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933878Ab0JSKFz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 06:05:55 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:9545 "EHLO sjogate2.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933798Ab0JSKFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 06:05:54 -0400
Message-ID: <4CBD6D75.4070908@atmel.com>
Date: Tue, 19 Oct 2010 12:05:41 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        phorton@bitbox.co.uk
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        avictor.za@gmail.com
Subject: Re: [PATCH 1/5] Fix AT91SAM9G20 reset as per the errata in the data
 sheet
References: <20100528153725.GA5102@axolotl.localnet> <29a192a1f4f98dd05b72ed8eafe67bd6aadd8432.1287076894.git.nicolas.ferre@atmel.com> <20101015122902.GF11127@game.jcrosoft.org>
In-Reply-To: <20101015122902.GF11127@game.jcrosoft.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 15/10/2010 14:29, Jean-Christophe PLAGNIOL-VILLARD :
>> +at91sam9g20_reset:	mov	r0, #0
>> +			mcr	p15, 0, r0, c7, c5, 0	@ flush I-cache
> do we really need to flush the I-cache again

You are right, it is done in the calling function: arm_machine_restart().

I will correct it in the patch series.

Best regards,
-- 
Nicolas Ferre

