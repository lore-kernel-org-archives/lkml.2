Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062Ab1EKPqc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:46:32 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:25787 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755003Ab1EKPqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:46:30 -0400
Message-ID: <4DCA4A12.7050300@atmel.com>
Date: Wed, 11 May 2011 10:34:26 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Andrew Victor <avictor.za@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Maxim Osipov <maxim.osipov@gmail.com>
CC: Russell King <linux@arm.linux.org.uk>, Andrew Victor <linux@maxim.org.za>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] AT91: Add external RTC for Flexibity board
References: <4DC53134.8070706@gmail.com>	<20110510234526.GC18929@game.jcrosoft.org> <BANLkTikvCiXgnm_hVTqDmzZ6yDf6H5WaCw@mail.gmail.com>
In-Reply-To: <BANLkTikvCiXgnm_hVTqDmzZ6yDf6H5WaCw@mail.gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 11/05/2011 09:44, Andrew Victor :
> hi,
> 
>>> This patch enables external RTC support on AT91 Flexibity board.
> 
> Acked-by: Andrew Victor <linux@maxim.org.za>
> 
> Maxim: You can submit it to Russell's patch system. 
> 
>> looks fine just one comment please add your board to the new at91sam9260_defconfig
> 
> That file does not exist in any mainline kernel.

Absolutely, we will come back on this when this common defconfig will be
properly included in mainline.

Bye,
-- 
Nicolas Ferre

