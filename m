Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612Ab1BJQp2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 11:45:28 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:7744 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820Ab1BJQp1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 11:45:27 -0500
X-PGP-Universal: processed;
	by hqnvupgp03.nvidia.com on Thu, 10 Feb 2011 08:45:23 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Colin Cross <ccross@android.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "olof@lixom.net" <olof@lixom.net>,
        "konkers@android.com" <konkers@android.com>,
        Gary King <gking@nvidia.com>, Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 10 Feb 2011 08:45:21 -0800
Subject: RE: [PATCH v4 10/15] ARM: tegra: iomap: Add missing devices, fix
 use of SZ_8, SZ_64
Thread-Topic: [PATCH v4 10/15] ARM: tegra: iomap: Add missing devices, fix
 use of SZ_8, SZ_64
Thread-Index: AcvI7h6oQtR6h1tQT2CRvd3Y6DU5CQAU65Vw
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF0310F60414@HQMAIL01.nvidia.com>
References: <1297320204-31882-1-git-send-email-ccross@android.com>
 <1297320204-31882-11-git-send-email-ccross@android.com>
In-Reply-To: <1297320204-31882-11-git-send-email-ccross@android.com>
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

Colin Cross wrote at Wednesday, February 09, 2011 11:43 PM:
> 
> From: Gary King <gking@nvidia.com>
> 
> Adds gart, hdmi, avp, host1x, and pwm controllers to mach/iomap.h
> There is no SZ_8 or SZ_64, replace them with constants

Can't we add those SZ_* constants?

-- 
nvpublic

