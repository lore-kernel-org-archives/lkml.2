Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161064Ab2KNKIc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 05:08:32 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:39840 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964793Ab2KNKIb (ORCPT <rfc822;linux-kernel@Vger.kernel.org>);
	Wed, 14 Nov 2012 05:08:31 -0500
Message-ID: <50A36D9A.2020509@ti.com>
Date: Wed, 14 Nov 2012 10:08:26 +0000
From: Liam Girdwood <lrg@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: core: Add regulator_is_supported_voltage_tol()
References: <1352879249-6074-1-git-send-email-broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1352879249-6074-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/11/12 07:47, Mark Brown wrote:
> If consumers wish to set voltages based on a tolerance it stands to reason
> that they will also want to query for support in the same manner.
>
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Acked-by: Liam Girdwood <lrg@ti.com>

