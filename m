Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867Ab0JSPqu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 11:46:50 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:50291 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458Ab0JSPqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 11:46:49 -0400
From: Kevin Hilman <khilman@deeprootsystems.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sekhar Nori <nsekhar@ti.com>, Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: linux-next: manual merge of the davinci tree with the arm tree
Organization: Deep Root Systems, LLC
References: <20101018103152.33fa12cd.sfr@canb.auug.org.au>
Date: Tue, 19 Oct 2010 08:46:41 -0700
In-Reply-To: <20101018103152.33fa12cd.sfr@canb.auug.org.au> (Stephen
	Rothwell's message of "Mon, 18 Oct 2010 10:31:52 +1100")
Message-ID: <87k4le18ym.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> writes:

> Hi Kevin,
>
> Today's linux-next merge of the davinci tree got a conflicts in
> arch/arm/mach-davinci/board-da830-evm.c and
> arch/arm/mach-davinci/board-da850-evm.c between commit
> 861bd81ee62a0d6759144c22909a8a3938951656 ("arm: remove
> machine_desc.io_pg_offst and .phys_io") from the arm tree and commit
> 48ea89eabee96019a4a84615af921f8703320abb ("davinci: introduce support for
> AM1x ARM9 microprocessors") from the davinci tree.
>
> Just context changes,  I fixed them up (see below) and can carry the fix
> as necessary.

Hi Stephen,

Thanks for carrying this.

Russell has (temporarily) dropped his version of the patch, but when he
adds it back (today, I believe) I will fix this up in the davinci tree
by pre-merging his branch with mine to handle this conflict.

Kevin
