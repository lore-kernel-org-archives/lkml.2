Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094Ab1GFG3A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 02:29:00 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:12090 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648Ab1GFG27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 02:28:59 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 05 Jul 2011 23:28:52 -0700
Message-ID: <4E1400A1.4030104@nvidia.com>
Date: Wed, 6 Jul 2011 15:28:49 +0900
From: Jinyoung Park <jinyoungp@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ko; rv:1.9.2.18) Gecko/20110616 Thunderbird/3.1.11
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 1/2] regulator: aat2870: Fix the logic of checking if
 no id is matched in aat2870_get_regulator
References: <1309923277.26847.5.camel@phoenix>
In-Reply-To: <1309923277.26847.5.camel@phoenix>
X-NVConfidentiality: public
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Axel

  > In current implementation, the pointer ri is not NULL if no id is 
matched.
  > Fix it by checking i == ARRAY_SIZE(aat2870_regulators) if no id is 
matched.
You are right, the ri never be NULL in current implementation.
That's my mistake, I didn't find it when writing and verifying the driver.

Thanks,
Jin.
