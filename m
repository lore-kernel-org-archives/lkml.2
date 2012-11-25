Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991Ab2KYNVn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 08:21:43 -0500
Received: from gate.crashing.org ([63.228.1.57]:42493 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752549Ab2KYNVm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 08:21:42 -0500
Subject: Re: [PATCH 1/2] powerpc/dma/raidengine: add raidengine device
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1353488481-14371-1-git-send-email-b29237@freescale.com>
Date: Sun, 25 Nov 2012 07:21:23 -0600
Cc: <dan.j.williams@gmail.com>, <vinod.koul@intel.com>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <iws@ovro.caltech.edu>, Harninder Rai <harninder.rai@freescale.com>,
        Naveen Burmi <naveenburmi@freescale.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <879B3D41-9FBD-4BC8-A682-6C4B9244EF12@kernel.crashing.org>
References: <1353488481-14371-1-git-send-email-b29237@freescale.com>
To: "<b29237@freescale.com>" <b29237@freescale.com>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 21, 2012, at 3:01 AM, <b29237@freescale.com> <b29237@freescale.com> wrote:

> From: Xuelin Shi <b29237@freescale.com>
> 
> The RaidEngine is a new Freescale hardware that used for parity
> computation offloading in RAID5/6.
> 
> This patch adds the device node in device tree and related binding
> documentation.
> 
> Signed-off-by: Harninder Rai <harninder.rai@freescale.com>
> Signed-off-by: Naveen Burmi <naveenburmi@freescale.com>
> Signed-off-by: Xuelin Shi <b29237@freescale.com>
> ---
> .../devicetree/bindings/powerpc/fsl/raideng.txt    |   81 +++++++++++++++++++
> arch/powerpc/boot/dts/fsl/p5020si-post.dtsi        |    1 +
> arch/powerpc/boot/dts/fsl/p5020si-pre.dtsi         |    6 ++
> arch/powerpc/boot/dts/fsl/qoriq-raid1.0-0.dtsi     |   85 ++++++++++++++++++++
> 4 files changed, 173 insertions(+)
> create mode 100644 Documentation/devicetree/bindings/powerpc/fsl/raideng.txt
> create mode 100644 arch/powerpc/boot/dts/fsl/qoriq-raid1.0-0.dtsi

applied to next

- k