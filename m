Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758113Ab2AKUsm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 15:48:42 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:7193 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab2AKUsj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 15:48:39 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 11 Jan 2012 12:48:27 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Laxman Dewangan <ldewangan.com@nvidia.com>,
        "ccross@android.com" <ccross@android.com>,
        "olof@lixom.net" <olof@lixom.net>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Date: Wed, 11 Jan 2012 12:48:26 -0800
Subject: RE: [PATCH V1] ARM: tegra: Pause DMA when reading transfer count
Thread-Topic: [PATCH V1] ARM: tegra: Pause DMA when reading transfer count
Thread-Index: AczPXjrXLG46KouVQnKzTBfCvwOlzgBQ/W9g
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF177EE3A77E@HQMAIL01.nvidia.com>
References: <1326175511-28642-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1326175511-28642-1-git-send-email-ldewangan@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Laxman Dewangan wrote at Monday, January 09, 2012 11:05 PM:
> In order to read an accurate channel transfer count
> from the APB DMA engine, the DMA controller must be
> paused first.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>

Acked-by: Stephen Warren <swarren@nvidia.com>
Tested-by: Stephen Warren <swarren@nvidia.com>

(Audio playback on Harmony booted using device tree works fine in my
brief testing)

-- 
nvpublic


