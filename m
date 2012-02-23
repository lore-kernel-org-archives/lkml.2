Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266Ab2BWRBI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 12:01:08 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:5737 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406Ab2BWRBH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 12:01:07 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 23 Feb 2012 09:00:57 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 23 Feb 2012 09:00:55 -0800
Subject: RE: [PATCH] ARM: tegra: Avoid compiling cpuidle code when not
 configured
Thread-Topic: [PATCH] ARM: tegra: Avoid compiling cpuidle code when not
 configured
Thread-Index: AczyR0yxAUYimnP0TQS8XXPR7YcJMQABUBqg
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF17BD8BC984@HQMAIL01.nvidia.com>
References: <1330014112-26203-1-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1330014112-26203-1-git-send-email-pdeschrijver@nvidia.com>
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

Peter De Schrijver wrote at Thursday, February 23, 2012 9:22 AM:
> No need to compile cpuidle.c and sleep.S if cpuidle isn't configured in the
> kernel.
> 
> Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>

It doesn't really need it since it's such a small change, but since I
bothered to compile-test it:

Acked-by: Stephen Warren <swarren@nvidia.com>
Tested-by: Stephen Warren <swarren@nvidia.com>

-- 
nvpublic

