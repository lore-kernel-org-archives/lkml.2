Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301Ab2BZXmY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 18:42:24 -0500
Received: from gate.crashing.org ([63.228.1.57]:33460 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752492Ab2BZXmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 18:42:23 -0500
Message-ID: <1330299728.20389.60.camel@pasglop>
Subject: Re: [PATCH 2/2] powerpc: Board support for GE IMP3A
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Martyn Welch <martyn.welch@ge.com>
Cc: linuxppc-dev@lists.ozlabs.org, Wim Van Sebroeck <wim@iguana.be>,
        Kumar Gala <galak@kernel.crashing.org>, linux-kernel@vger.kernel.org
Date: Mon, 27 Feb 2012 10:42:08 +1100
In-Reply-To: <1328614121-17803-3-git-send-email-martyn.welch@ge.com>
References: <1328614121-17803-1-git-send-email-martyn.welch@ge.com>
	 <1328614121-17803-3-git-send-email-martyn.welch@ge.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-07 at 11:28 +0000, Martyn Welch wrote:
> +
> +       if (of_flat_dt_is_compatible(root, "fsl,MPC8572DS-CAMP")) {
> +               mpic = mpic_alloc(NULL, 0,
> +                       MPIC_BIG_ENDIAN | MPIC_BROKEN_FRR_NIRQS |
> +                       MPIC_SINGLE_DEST_CPU,
> +                       0, 256, " OpenPIC  ");
> +       } else {
> +               mpic = mpic_alloc(NULL, 0,
> +                         MPIC_WANTS_RESET |
> +                         MPIC_BIG_ENDIAN | MPIC_BROKEN_FRR_NIRQS |
> +                         MPIC_SINGLE_DEST_CPU,
> +                       0, 256, " OpenPIC  ");
> +       }
> + 

Can you rebase this on top of powerpc-next ? There have been some mpic
changes from Kyle Moffett that clash with this (mostly some of the flags
are gone, the remaining ones you should just put in the device-tree).

Cheers,
Ben.


