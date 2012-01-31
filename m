Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057Ab2AaQzk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 11:55:40 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:10026 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444Ab2AaQzi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 11:55:38 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 31 Jan 2012 08:55:29 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Barry Song <Barry.Song@csr.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "workgroup.linux@csr.com" <workgroup.linux@csr.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Barry Song <Baohua.Song@csr.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Erik Gilling <konkers@google.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Date: Tue, 31 Jan 2012 08:55:28 -0800
Subject: RE: [PATCH 2/3] GPIO: TEGRA: move to use
 platform_devm_request_and_ioremap() helper
Thread-Topic: [PATCH 2/3] GPIO: TEGRA: move to use
 platform_devm_request_and_ioremap() helper
Thread-Index: AczgBIkn1GBr9ss/RF63MUXCtSc+twANG7WQ
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF178E12440C@HQMAIL01.nvidia.com>
References: <1328004002-24646-1-git-send-email-Barry.Song@csr.com>
 <1328004002-24646-3-git-send-email-Barry.Song@csr.com>
In-Reply-To: <1328004002-24646-3-git-send-email-Barry.Song@csr.com>
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

Barry Song wrote at Tuesday, January 31, 2012 3:00 AM:
> [no description]
> Signed-off-by: Barry Song <Baohua.Song@csr.com>

Acked-by: Stephen Warren <swarren@nvidia.com>

-- 
nvpublic

