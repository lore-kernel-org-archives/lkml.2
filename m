Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279Ab1JOAeJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 20:34:09 -0400
Received: from tundra.namei.org ([65.99.196.166]:55410 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754322Ab1JOAeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 20:34:07 -0400
Date: Sat, 15 Oct 2011 11:34:00 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
cc: linux-security-module@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, zohar@linux.vnet.ibm.com,
        dhowells@redhat.com, herbert@gondor.hengli.com.au
Subject: Re: [PATCH v2.1 4/7] crypto: GnuPG based MPI lib - additional sources
 (part 4)
In-Reply-To: <81f834dca8feb889e2acbc666e730cf89b5d5c41.1318598705.git.dmitry.kasatkin@intel.com>
Message-ID: <alpine.LRH.2.00.1110151132430.24994@tundra.namei.org>
References: <cover.1318598705.git.dmitry.kasatkin@intel.com> <81f834dca8feb889e2acbc666e730cf89b5d5c41.1318598705.git.dmitry.kasatkin@intel.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Oct 2011, Dmitry Kasatkin wrote:

> +#if 0				/* not yet ported to MPI */
> +
> +mpi_limb_t
> +mpihelp_udiv_w_sdiv(mpi_limp_t *rp,
> +		    mpi_limp_t *a1, mpi_limp_t *a0, mpi_limp_t *d)

Drop this if it's not working.


-- 
James Morris
<jmorris@namei.org>
