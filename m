Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757869Ab0FUM44 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 08:56:56 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:51350 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757828Ab0FUM4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 08:56:53 -0400
Message-ID: <4C1F6142.3050004@atmel.com>
Date: Mon, 21 Jun 2010 14:55:30 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.1.10) Gecko/20100512 Lightning/1.0b1 Thunderbird/3.0.5
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: avictor.za@gmail.com, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] AT91: PM: dual ram controller support
References: <1273492287-7647-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <1273492287-7647-1-git-send-email-nicolas.ferre@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 10/05/2010 13:51, Nicolas Ferre :
> This rework allows to address tow memory controllers. AT91SAM9263 and
> AT91SAM9G45 family have tow SDRAM or DDR/SDRAM controllers. Power management
> should take care of this.
> This patch modify the way RAM IP header files are implemented to allow
> access to registers of both controllers ; it also adds some macros.
> 
> We also modify the power management files to use those modified header files.
> Slow clock (assembly) and regular power management functions are synchronized
> for setting of RAM self-refresh procedure: 
> (lpr & ~AT91_DDRSDRC_LPCB) | AT91_DDRSDRC_LPCB_SELF_REFRESH

Queued as patch 6185/1 with Ack from Andrew Victor.

http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=6185/1

Best regards,
-- 
Nicolas Ferre

