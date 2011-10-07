Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758332Ab1JGSBN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 14:01:13 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:3230 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758227Ab1JGSBL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 14:01:11 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Fri, 07 Oct 2011 11:00:58 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>, Erik Gilling <konkers@android.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Fri, 7 Oct 2011 11:00:55 -0700
Subject: RE: [PATCH v7 0/3] Add support for tegra2 based ventana board
Thread-Topic: [PATCH v7 0/3] Add support for tegra2 based ventana board
Thread-Index: AcyBzwxR7Ygy1jPsTFyAHWPLeVyUcQDS2McQ
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF173B23B2F1@HQMAIL01.nvidia.com>
References: <1317647918-22694-1-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1317647918-22694-1-git-send-email-pdeschrijver@nvidia.com>
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

Peter De Schrijver wrote at Monday, October 03, 2011 7:19 AM:
> This patch set adds support for the tegra2 based ventana development board.
> 
> Boot tested on ventana.

With minor changes to the command-line in tegra-ventana.dts, to put the
root fs on an SD card, and using mainline U-Boot with the Ventana patch
series I wrote,

Tested-by: Stephen Warren <swarren@nvidia.com>

I have a couple of queries in patch 3 that I'll post separately.

-- 
nvpublic

