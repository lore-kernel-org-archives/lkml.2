Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884Ab0CQPj2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 11:39:28 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:48210 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731Ab0CQPj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 11:39:27 -0400
Date: Wed, 17 Mar 2010 16:39:18 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Andrea Gelmini <andrea.gelmini@gelma.net>
Cc: linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
       linux-mips@linux-mips.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH 42/66] arch/mips/lib/libgcc.h: Checkpatch cleanup
Message-ID: <20100317153918.GD4554@linux-mips.org>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
 <1267289508-31031-43-git-send-email-andrea.gelmini@gelma.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267289508-31031-43-git-send-email-andrea.gelmini@gelma.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 27, 2010 at 05:51:23PM +0100, Andrea Gelmini wrote:
> From: Andrea Gelmini <andrea.gelmini@gelma.net>
> Date:   Sat, 27 Feb 2010 17:51:23 +0100
> To: linux-kernel@vger.kernel.org
> Cc: Andrea Gelmini <andrea.gelmini@gelma.net>,
> 	Ralf Baechle <ralf@linux-mips.org>,
> 	Paul Mundt <lethal@linux-sh.org>, linux-mips@linux-mips.org,
> 	linux-sh@vger.kernel.org
> Subject: [PATCH 42/66] arch/mips/lib/libgcc.h: Checkpatch cleanup
> 
> arch/mips/lib/libgcc.h:21: ERROR: open brace '{' following union go on the same line
> 
> Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
> ---
>  arch/mips/lib/libgcc.h |    3 +--
>  arch/sh/lib/libgcc.h   |    3 +--
>  2 files changed, 2 insertions(+), 4 deletions(-)

I've applied the MIPS portion of the patch, thanks.

  Ralf
