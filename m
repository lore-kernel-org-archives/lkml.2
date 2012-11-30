Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758686Ab2K3QtM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 11:49:12 -0500
Received: from void.printf.net ([89.145.121.20]:48805 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756580Ab2K3QtK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 11:49:10 -0500
From: Chris Ball <cjb@laptop.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Kevin Liu <keyuan.liu@gmail.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, lrg@ti.com,
        Philip Rakity <prakity@nvidia.com>
Subject: Re: FW: [PATCH v2] mmc: sdhci: apply voltage range check only for non-fixed regulators
References: <25B60CDC2F704E4E9D88FFD52780CB4C060FBEA29A@SC-VEXCH1.marvell.com>
	<CADz5_gLC=z_VYrNq8q3dU7L6im7shSz-Sn6Tzym2mRZONwpgUg@mail.gmail.com>
	<50AB34E2.1010206@samsung.com>
	<CADz5_gKdUq8bjuMr1=yo65ysHzLNvKnrfVuSpLk-Q6ek-TWpNA@mail.gmail.com>
	<50AB587F.3040405@samsung.com>
	<CADz5_gJ1hV3n-4BPgBNT9LDp2-E=vNNzMGx=_9PmzT0RJ9+TsA@mail.gmail.com>
	<50AB81C8.4090300@samsung.com>
	<CADz5_gL3uHbvhb2ccp03=9P88u1Catxe9+Xffs3KmJsZGWmWvA@mail.gmail.com>
	<50AB9B90.1030404@samsung.com>
Date: Fri, 30 Nov 2012 11:48:59 -0500
In-Reply-To: <50AB9B90.1030404@samsung.com> (Marek Szyprowski's message of
	"Tue, 20 Nov 2012 16:02:40 +0100")
Message-ID: <87hao7f344.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marek,

On Tue, Nov 20 2012, Marek Szyprowski wrote:
> The problem with dummy regulator is the fact that it can be enabled only
> globally for all devices in the system. I think that the best solution
> would be to introduce regulator_can_change_voltage() as Mark suggested.
> I will post patches soon.

Does this mean that I shouldn't merge either yours or Kevin's patch for
3.8, while we wait for this?  Any ETA on it?

Thanks very much,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
