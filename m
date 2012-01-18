Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932389Ab2ARVMv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 16:12:51 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:17671 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757763Ab2ARVMt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 16:12:49 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 18 Jan 2012 13:12:48 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Stephen Warren <swarren@nvidia.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Rakesh Iyer <riyer@nvidia.com>
CC: "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 18 Jan 2012 13:12:46 -0800
Subject: RE: [PATCH 1/1] Input: tegra-kbc - remove pre Tegra20 definitions
Thread-Topic: [PATCH 1/1] Input: tegra-kbc - remove pre Tegra20 definitions
Thread-Index: AczVeF+5BK+tJLzERie8xpeePdCsXAAhfwLQAAnBnSA=
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF1780DAAF12@HQMAIL01.nvidia.com>
References: <1326842810-12039-1-git-send-email-riyer@nvidia.com>
 <20120118003012.GA27489@core.coreip.homeip.net>
 <74CDBE0F657A3D45AFBB94109FB122FF1780DAADCB@HQMAIL01.nvidia.com>
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF1780DAADCB@HQMAIL01.nvidia.com>
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

Stephen Warren wrote at Wednesday, January 18, 2012 9:36 AM:
> Dmitry Torokhov wrote at Tuesday, January 17, 2012 5:30 PM:
> > On Tue, Jan 17, 2012 at 03:26:50PM -0800, Rakesh Iyer wrote:
> > > Add support for Tegra30 by correcting definitions. This is necessary to
> > > make driver useful in Tegra30.
> >
> > So what about older versions? There still could be users...
> 
> I wonder if there will be problems with this patch; the loop in
> tegra_kbc_report_keys() is going to process 8 bits more of the last
> register and the loop in tegra_kbc_config_pins() will now touch one
> more row and one more column register. I think these loops should be
> limited at run-time based on the SoC actually being executed upon?

Sorry, I read the ifdef the wrong way around. The new values are for
Tegra20 and should have been in use all along. There are no old
versions to consider here, since chips before Tegra20 aren't supported
by mainline (or any??) Linux.

So,

Acked-by: Stephen Warren: <swarren@nvidia.com>

Sorry for the confusion.

-- 
nvpublic

