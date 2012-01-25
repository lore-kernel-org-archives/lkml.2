Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225Ab2AYArm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 19:47:42 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:15232 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755052Ab2AYArl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 19:47:41 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 24 Jan 2012 16:47:40 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Tony Lindgren <tony@atomide.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Barry Song <21cnbao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>
Date: Tue, 24 Jan 2012 16:47:38 -0800
Subject: RE: [PATCH 2/4] pinctrl: Fix pinmux_hog_maps when ctrl_dev_name is
 not set
Thread-Topic: [PATCH 2/4] pinctrl: Fix pinmux_hog_maps when ctrl_dev_name is
 not set
Thread-Index: Acza95o919a9TbycRDGPCXWkP1LnIgAAyKFA
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF178CB81F59@HQMAIL01.nvidia.com>
References: <20120120161610.21955.25082.stgit@kaulin.local>
 <20120120161727.21955.7437.stgit@kaulin.local>
 <74CDBE0F657A3D45AFBB94109FB122FF1780DAB383@HQMAIL01.nvidia.com>
 <20120120173915.GP22818@atomide.com> <20120125002340.GV22818@atomide.com>
In-Reply-To: <20120125002340.GV22818@atomide.com>
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

Tony Lindgren wrote at Tuesday, January 24, 2012 5:24 PM:
...
> The ctrl_dev_name is optional for struct pinmux_map assuming
> that ctrl_dev is set. Without this patch we can get:
> 
> Unable to handle kernel NULL pointer dereference at virtual address 00000000
> ...
> (pinmux_hog_maps+0xa4/0x20c)
> (pinctrl_register+0x2a4/0x378)
> ...
> 
> Fix this by adding adding a test for map->ctrl_dev.
> Additionally move the test for map->ctrl_dev earlier
> to optimize out the loop a bit.
> 
> Signed-off-by: Tony Lindgren <tony@atomide.com>

Acked-by: Stephen Warren <swarren@nvidia.com>

-- 
nvpublic

