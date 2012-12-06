Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686Ab2LFFgB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 00:36:01 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:15996 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554Ab2LFFgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 00:36:00 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 05 Dec 2012 21:35:59 -0800
Message-ID: <50C02EBF.2080506@nvidia.com>
Date: Thu, 6 Dec 2012 11:05:59 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
CC: Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mfd: tps80031: Add terminating entry for tps80031_id_table
References: <1354712340.4261.0.camel@phoenix>
In-Reply-To: <1354712340.4261.0.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 December 2012 06:29 PM, Axel Lin wrote:
> The i2c_device_id table is supposed to be zero-terminated.
>
> Signed-off-by: Axel Lin<axel.lin@ingics.com>

Acked-by: Laxman Dewangan <ldewangan@nvidia.com>
