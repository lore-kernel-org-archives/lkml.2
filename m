Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab1JLP5G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 11:57:06 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5351 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270Ab1JLP5E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 11:57:04 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 12 Oct 2011 08:56:49 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Date: Wed, 12 Oct 2011 08:56:47 -0700
Subject: RE: [PATCH v9 0/3] Add support for tegra2 based ventana board
Thread-Topic: [PATCH v9 0/3] Add support for tegra2 based ventana board
Thread-Index: AcyI1Zg3M128TVtsQOaLEm/LPRxldQAIdGFA
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF173BE19D81@HQMAIL01.nvidia.com>
References: <1318420387-6802-1-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1318420387-6802-1-git-send-email-pdeschrijver@nvidia.com>
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

pdeschrijver@nvidia.com wrote at Wednesday, October 12, 2011 5:53 AM:
> This patch set adds support for the tegra2 based ventana development board.
> 
> Boot tested on ventana.
> 
> Uses a table based approach to select the correct init function.
> 
> Provoke kernel warning when no suitable pinmux table can be found.

Whole series:

Acked-by: Stephen Warren <swarren@nvidia.com>

Thanks for following up on my picky comments:-)

--
nvpublic

