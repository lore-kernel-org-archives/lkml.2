Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710Ab2BUFjm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 00:39:42 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:17081 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab2BUFjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 00:39:39 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 20 Feb 2012 21:39:25 -0800
Message-ID: <4F432D7A.7030805@nvidia.com>
Date: Tue, 21 Feb 2012 11:06:58 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mike Rapoport <mike@compulab.co.il>, Cyril Chemparathy <cyril@ti.com>,
        Graeme Gregory <gg@slimlogic.co.uk>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] regulator: Group TI TPSxxxxx regulators together
References: <1329799491.7033.1.camel@phoenix>
In-Reply-To: <1329799491.7033.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 21 February 2012 10:14 AM, Axel Lin wrote:
> Group TI TPSxxxxx regulators together and sort them in alphabetical order.
> This change makes it easier for users to find config options.
>
> Signed-off-by: Axel Lin<axel.lin@gmail.com>
> Cc: Mike Rapoport<mike@compulab.co.il>
> Cc: Cyril Chemparathy<cyril@ti.com>
> Cc: Graeme Gregory<gg@slimlogic.co.uk>
> Cc: Laxman Dewangan<ldewangan@nvidia.com>
> ---
Should we only arrange the tps regulators or all regulators in 
alphabetical order?
I will prefer to arrange all which inherently will arrange tps as all ti 
regulators start with tps..
