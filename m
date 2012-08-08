Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122Ab2HHV5J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 17:57:09 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:45876 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999Ab2HHV5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 17:57:07 -0400
Message-ID: <5022E0B0.1070406@wwwdotorg.org>
Date: Wed, 08 Aug 2012 15:57:04 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: broonie@opensource.wolfsonmicro.com
CC: Laxman Dewangan <ldewangan@nvidia.com>, lrg@ti.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: tps6586x: correct vin pin for sm0/sm1/sm2
References: <1343117880-11576-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1343117880-11576-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2012 02:18 AM, Laxman Dewangan wrote:
> As per datasheet, the vin pin for the regulator is named
> as vin_sm0, vin_sm1, vin_sm2 for sm0, sm1 and sm2 respectively.
> 
> Correcting the names in driver and documentation to match with
> datasheet.

Mark,

This patch was in next-20120803, but seems to have been dropped from
next-20120806 and later:

> git log next-20120803 --oneline -- drivers/regulator/tps6586x-regulator.c|cat
> c7bc4e5 regulator: tps6586x: correct vin pin for sm0/sm1/sm2
> 7c7fac3 regulator: tps6586x: add support for input supply
> f464703 regulator: tps6586x: Convert to regulator_list_voltage_table

> git log next-20120806 --oneline -- drivers/regulator/tps6586x-regulator.c|cat
> 4c79c8d regulator: tps6586x: Convert to regulator_[enable|disable|is_enabled|get_voltage_sel]_regmap
> 7c7fac3 regulator: tps6586x: add support for input supply
> f464703 regulator: tps6586x: Convert to regulator_list_voltage_table

I assume that was just an accident?

