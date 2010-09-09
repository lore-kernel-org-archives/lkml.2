Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165Ab0IIJyF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 05:54:05 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:56820 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348Ab0IIJyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 05:54:04 -0400
Date: Thu, 9 Sep 2010 11:53:59 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: Kevin Cernekee <cernekee@gmail.com>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] MIPS: Allow UserLocal on MIPS_R1 processors
Message-ID: <20100909095359.GA27815@linux-mips.org>
References: <064bb0722da5d8c271c2bd9fe0a521cc@localhost>
 <d57a8d9cc346a9235a93e528beac4c40@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d57a8d9cc346a9235a93e528beac4c40@localhost>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 08, 2010 at 04:02:14PM -0700, Kevin Cernekee wrote:

> Some MIPS32R1 processors implement UserLocal (RDHWR $29) to accelerate
> programs that make extensive use of thread-local storage.  Therefore,
> setting up the HWRENA register should not depend on cpu_has_mips_r2.

Interesting - which R1 processor has RDHWR?  When UserLocal was conceived
R2 was already long released.

  Ralf
