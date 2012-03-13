Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914Ab2CMFcR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 01:32:17 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:10629 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754660Ab2CMFcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 01:32:16 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 12 Mar 2012 22:32:06 -0700
Message-ID: <4F5EDAF1.6060606@nvidia.com>
Date: Tue, 13 Mar 2012 10:58:17 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>,
        Graeme Gregory <gg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: Fix the logic of tps65910_get_mode
References: <1331594127.5392.3.camel@phoenix>
In-Reply-To: <1331594127.5392.3.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 March 2012 04:45 AM, Axel Lin wrote:
> We actually clear LDO_ST_ON_BIT for standby mode in tps65910_set_mode.
> Fix the logic in tps65910_get_mode.
>
> Supply state (EEPROM bits):
> ST[1:0] = 00 : Off
> ST[1:0] = 01 : On high power (ACTIVE)
> ST[1:0] = 10 : Off
> ST[1:0] = 11 : On low power (SLEEP)
>
> Signed-off-by: Axel Lin<axel.lin@gmail.com>
> ---

Acked-by: Laxman Dewangan <ldewangan@nvidia.com>
