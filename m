Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757403Ab1CRUuE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 16:50:04 -0400
Received: from gate.crashing.org ([63.228.1.57]:48216 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756949Ab1CRUt6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 16:49:58 -0400
Subject: Re: [PATCH -mm] RapidIO,powerpc/85xx: Fix configuration option
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1300468735-1158-1-git-send-email-alexandre.bounine@idt.com>
Date: Fri, 18 Mar 2011 15:49:00 -0500
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>, Thomas Moll <thomas.moll@sysgo.com>
Content-Transfer-Encoding: 7bit
Message-Id: <8E8332C6-1F17-4EC1-BD04-7B93D7B49640@kernel.crashing.org>
References: <1300468735-1158-1-git-send-email-alexandre.bounine@idt.com>
To: Alexandre Bounine <alexandre.bounine@idt.com>
X-Mailer: Apple Mail (2.1082)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 18, 2011, at 12:18 PM, Alexandre Bounine wrote:

> Follows set of patches in -mm tree. Replaces configuration option
> missed in previous patches.
> 
> Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
> ---
> arch/powerpc/kernel/cpu_setup_fsl_booke.S |    2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)

Acked-by: Kumar Gala <galak@kernel.crashing.org>

Alex, I can push this via the powerpc.git tree route if you want.

- k
