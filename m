Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab1J0USU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 16:18:20 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:8935 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202Ab1J0UST convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 16:18:19 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 27 Oct 2011 13:18:09 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Date: Thu, 27 Oct 2011 13:18:07 -0700
Subject: RE: [PATCH 5/6] arm/tegra: pinmux tables and definitions for tegra30
Thread-Topic: [PATCH 5/6] arm/tegra: pinmux tables and definitions for
 tegra30
Thread-Index: AcyTNsTIF+jknqVFQs6K5vk1CA8r+gBreFWw
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF173E1B49C4@HQMAIL01.nvidia.com>
References: <1319561644-6160-1-git-send-email-pdeschrijver@nvidia.com>
 <1319561644-6160-6-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1319561644-6160-6-git-send-email-pdeschrijver@nvidia.com>
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

Peter De Schrijver wrote at Tuesday, October 25, 2011 10:54 AM:
> Define the pinmuxing and pindrive tables for tegra30. The pinmux table defines
> the available functions for each pinmux group. The pindrive table defines the
> default pullup or pulldowns for each group.

This is almost fine.

You added some new fields to struct tegra_pingroup_desc. This should be
noted in the change description, pointing out that there are new HW
features on Tegra30, but that the driver hasn't been updated to support
them. You probably want to actually add those new fields in a separate
patch before-hand, so you can modify pinmux-tegra20-tables.c to set all
those reg fields to -1, so if/when the driver does support the fields,
Tegra20 will indicate it doesn't support those parameters.

-- 
nvpublic

