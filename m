Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386Ab1HPC1W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 22:27:22 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:6146 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266Ab1HPC1G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 22:27:06 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 15 Aug 2011 19:26:33 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Doug Anderson <dianders@chromium.org>, Ben Dooks <ben-linux@fluff.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        Rhyland Klein <rklein@nvidia.com>, Felipe Balbi <balbi@ti.com>
CC: Jean Delvare <khali@linux-fr.org>, Rakesh Iyer <riyer@nvidia.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Mon, 15 Aug 2011 19:26:30 -0700
Subject: RE: [PATCH v2] i2c: tegra: Check for overflow errors with BUG_ON.
Thread-Topic: [PATCH v2] i2c: tegra: Check for overflow errors with BUG_ON.
Thread-Index: AcxbtHeNkQNf9+gGTaiCgS7DGOhURgAB01yg
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF04AEA252A8@HQMAIL01.nvidia.com>
References: <1313434172-18319-1-git-send-email-dianders@chromium.org>
 <1313458336-31456-1-git-send-email-dianders@chromium.org>
In-Reply-To: <1313458336-31456-1-git-send-email-dianders@chromium.org>
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

Doug Anderson wrote at Monday, August 15, 2011 7:32 PM:
> This change doesn't fix any known problems but turns
> on the overflow detection feature of the i2c controller
> in the hopes of flushing out any current (or future)
> bugs in the i2c driver.
> 
> Inspired by a change on nvidia's git server:
>   http://nv-tegra.nvidia.com/gitweb/?p=linux-2.6.git;a=commit;h=266d1b7397284505e55d06254b497cb32be07b69
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
> This takes Felipe Balbi's suggestion of making the overflow
> error non-fatal.

This seems like a reasonable debug aid/validation check to me;
Acked-by: Stephen Warren <swarren@nvidia.com>

-- 
nvpublic

