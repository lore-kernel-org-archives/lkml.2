Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932462Ab2BXXMp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 18:12:45 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:16433 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932264Ab2BXXMm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 18:12:42 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 24 Feb 2012 15:12:38 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Date: Fri, 24 Feb 2012 15:12:37 -0800
Subject: RE: [PATCH] gpio: tegra: Fix build issue due to irq_domain rework.
Thread-Topic: [PATCH] gpio: tegra: Fix build issue due to irq_domain rework.
Thread-Index: AczqpjCF3U6KAv9jQXyi++AmujpMgwIo2B4g
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF17BD8BCE0C@HQMAIL01.nvidia.com>
References: <1329175275-19404-1-git-send-email-swarren@nvidia.com>
In-Reply-To: <1329175275-19404-1-git-send-email-swarren@nvidia.com>
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

Stephen Warren wrote at Monday, February 13, 2012 4:21 PM:
> Commit 7da5a66 "irq_domain: Remove 'new' irq_domain in favour of the
> ppc one" changed the set of available irq domain APIs. Update the Tegra
> GPIO driver to account for those changes, to solve a build break.

Grant, Linus,

Could this please be checked in; linux-next since about Feb 6th doesn't
build for Tegra without it.

Thanks.

-- 
nvpublic

