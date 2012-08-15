Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948Ab2HOK5c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 06:57:32 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:48637 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317Ab2HOK5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 06:57:30 -0400
Date: Wed, 15 Aug 2012 12:57:20 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: David Daney <ddaney.cavm@gmail.com>
Cc: linux-mips@linux-mips.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH 0/2] Align MIPS swapper_pg_dir for faster code.
Message-ID: <20120815105720.GA6270@linux-mips.org>
References: <1344967681-13179-1-git-send-email-ddaney.cavm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344967681-13179-1-git-send-email-ddaney.cavm@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 11:07:59AM -0700, David Daney wrote:

> From: David Daney <david.daney@cavium.com>
> 
> The MIPS swapper_pg_dir needs 64K alignment for faster TLB refills in
> kernel mappings.  There are two parts to the patch set:
> 
> 1) Modify generic vmlinux.lds.h to allow architectures to place
>    additional sections at the start of .bss.  This allows alignment
>    constraints to be met with minimal holes added for padding.
>    Putting this in common code should reduce the risk of future
>    changes to the linker scripts not being propagated to MIPS (or any
>    other architecture that needs something like this).
> 
> 2) Align the MIPS swapper_pg_dir.
> 
> Since the initial use of the code is for MIPS, perhaps both parts
> could be merged by Ralf's tree (after collecting any Acked-bys).

Looks good to me but will wait a bit longer for comments and (N)Acks
before merging.

  Ralf
