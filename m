Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423Ab2AZSeh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 13:34:37 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:16325 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067Ab2AZSef convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 13:34:35 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 26 Jan 2012 10:34:24 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 26 Jan 2012 10:33:40 -0800
Subject: RE: [PATCH v1 0/3] Add support for LP3
Thread-Topic: [PATCH v1 0/3] Add support for LP3
Thread-Index: AczcRrBL+IV7cappQieuFa6EA8nZogAEhj/g
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF178CB823CD@HQMAIL01.nvidia.com>
References: <1327594923-21822-1-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1327594923-21822-1-git-send-email-pdeschrijver@nvidia.com>
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

Peter De Schrijver wrote at Thursday, January 26, 2012 9:22 AM:
> Introduce support for LP3 (CPU core clockgating) for Tegra20 and Tegra30.

The series,

Acked-by: Stephen Warren <swarren@nvidia.com>

(although I'm not very familiar with cpuidle, so a review from e.g.
Colin would be great too)

Tested-by: Stephen Warren <swarren@nvidia.com>

(On Harmony, observed /sys/devices/system/cpu/cpu*/cpuidle/state0/usage
incrementing over time. Tested audio playback as well)

-- 
nvpublic

