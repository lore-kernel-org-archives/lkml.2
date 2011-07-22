Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922Ab1GVI3T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 04:29:19 -0400
Received: from gate.crashing.org ([63.228.1.57]:54046 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752468Ab1GVI3R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 04:29:17 -0400
Subject: Re: [PATCH v2] powerpc/85xx: fix mpic configuration in CAMP mode
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1310456983-1473-1-git-send-email-fabio.baltieri@gmail.com>
Date: Fri, 22 Jul 2011 03:28:58 -0500
Cc: Scott Wood <scottwood@freescale.com>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>,
        Poonam Aggrwal <poonam.aggrwal@freescale.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <CA92D37F-3668-496A-869C-95D44FEB9837@kernel.crashing.org>
References: <20110711143859.0e6c95d8@schlenkerla.am.freescale.net> <1310456983-1473-1-git-send-email-fabio.baltieri@gmail.com>
To: Fabio Baltieri <fabio.baltieri@gmail.com>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 12, 2011, at 2:49 AM, Fabio Baltieri wrote:

> Change the string to check for CAMP mode boot on MPC85xx (eg. P2020) to match
> the one in the corresponding dts files (p2020rdb_camp_core{0,1}.dts).
> 
> Without this fix the mpic is configured as in the SMP boot mode, which causes
> the first core to report a protected source interrupt error for devices
> of the other core and lock up.
> 
> Also add MPIC_SINGLE_DEST_CPU on both P2020 based architectures in CAMP
> mode as suggested by Scott Wood. Thanks.
> 
> Cc: Scott Wood <scottwood@freescale.com>
> Cc: Poonam Aggrwal <poonam.aggrwal@freescale.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Signed-off-by: Fabio Baltieri <fabio.baltieri@gmail.com>
> ---
> arch/powerpc/platforms/85xx/mpc85xx_ds.c  |    3 ++-
> arch/powerpc/platforms/85xx/mpc85xx_rdb.c |    5 +++--
> 2 files changed, 5 insertions(+), 3 deletions(-)

applied to next

- k