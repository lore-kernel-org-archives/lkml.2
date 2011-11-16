Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011Ab1KPPfa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 10:35:30 -0500
Received: from gate.crashing.org ([63.228.1.57]:57683 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163Ab1KPPf3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 10:35:29 -0500
Subject: Re: [PATCH 3/5,v3] powerpc/85xx: Update SRIO device tree nodes
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1321099352-21462-3-git-send-email-Gang.Liu@freescale.com>
Date: Wed, 16 Nov 2011 09:35:11 -0600
Cc: <linuxppc-dev@lists.ozlabs.org>, <Alexandre.Bounine@idt.com>,
        <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <r58472@freescale.com>, <B11780@freescale.com>, <r61911@freescale.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <F2C5B7D0-98F0-45C2-A9CA-EF6A783B4485@kernel.crashing.org>
References: <1321099352-21462-1-git-send-email-Gang.Liu@freescale.com> <1321099352-21462-3-git-send-email-Gang.Liu@freescale.com>
To: Liu Gang <Gang.Liu@freescale.com>
X-Mailer: Apple Mail (2.1251.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 12, 2011, at 6:02 AM, Liu Gang wrote:

> From: Kumar Gala <galak@kernel.crashing.org>
> 
> Update all dts files that support SRIO controllers to match the new
> fsl,srio device tree binding.
> 
> Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
> ---
> arch/powerpc/boot/dts/mpc8568mds.dts   |   66 ++++++++++++++++++++++-------
> arch/powerpc/boot/dts/mpc8569mds.dts   |   72 +++++++++++++++++++++++++------
> arch/powerpc/boot/dts/mpc8641_hpcn.dts |   69 ++++++++++++++++++++++++-------
> arch/powerpc/boot/dts/p2041rdb.dts     |   11 +++++
> arch/powerpc/boot/dts/p2041si.dtsi     |   20 +++++++++
> arch/powerpc/boot/dts/p3041ds.dts      |   11 +++++
> arch/powerpc/boot/dts/p3041si.dtsi     |   26 ++++++++---
> arch/powerpc/boot/dts/p4080ds.dts      |   12 ++++-
> arch/powerpc/boot/dts/p4080si.dtsi     |   64 +++++++++++++++++++++++-----
> arch/powerpc/boot/dts/p5020ds.dts      |   11 +++++
> arch/powerpc/boot/dts/p5020si.dtsi     |   26 ++++++++---
> 11 files changed, 314 insertions(+), 74 deletions(-)

I'm holding off on this, since I'm reworking the .dts.  I'll workup a new patch based on top of the dts changes.

- k