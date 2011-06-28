Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793Ab1F1MPB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 08:15:01 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:38159 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757032Ab1F1MN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 08:13:57 -0400
Message-ID: <4E09C573.2030607@atmel.com>
Date: Tue, 28 Jun 2011 14:13:39 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.2.18) Gecko/20110616 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: balbi@ti.com
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        plagnioj@jcrosoft.com, avictor.za@gmail.com
Subject: Re: [PATCH] AT91: add AT91SAM9X5 dummy configuration variable
References: <1309260927-11411-1-git-send-email-nicolas.ferre@atmel.com> <20110628103549.GG2612@legolas.emea.dhcp.ti.com>
In-Reply-To: <20110628103549.GG2612@legolas.emea.dhcp.ti.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 28/06/2011 12:35, Felipe Balbi :
> On Tue, Jun 28, 2011 at 01:35:27PM +0200, Nicolas Ferre wrote:
>> Add this Kconfig variable to ease the submission of this chip support.
>> As this chip/board inclusion is dealayed due to deep consolidation of
>> arm/mach-at91 sources, we include this dummy configuration variable to allow
>> submission of SAM9x5 related drivers in other subsystems.
> 
> Why are the drivers even depending on this ? They should be portable
> enough. Can you share a few drivers so we have a look ?

Yes sure. The dependence is only on the Kconfig side: I plan to make
some drivers dependent on this configuration variable.
The goal is to submit the final driver addition without having to send
again a correction to the Kconfig after the chip/board support is merged.

This will ease the submission process at the cost of a two lines dummy
patch and will remove interdependence between subsystem trees: it worth
it, is not it?

> IMHO, the whole idea of the consolidation is beyond arch/arm, drivers
> should be affected too.

Yes sure, I also understood like this.
I will not spread ARCH_AT91SAM9X5 ifdef in driver code...

Best regards,
-- 
Nicolas Ferre

