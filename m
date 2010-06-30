Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757218Ab0F3Ugv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 16:36:51 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:49675 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755850Ab0F3Ugt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 16:36:49 -0400
Date: Wed, 30 Jun 2010 16:37:37 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Christoph Egger <siccegge@cs.fau.de>
Cc: Manuel Lauss <manuel.lauss@gmail.com>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org, vamos@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH 4/9] Removing dead CONFIG_MTD_PB1550_BOOT,
 CONFIG_MTD_PB1550_USER
Message-ID: <20100630153737.GA4982@linux-mips.org>
References: <cover.1275925108.git.siccegge@cs.fau.de>
 <038d00ad3c402eb0a941b034daecdc3603d82e37.1275925108.git.siccegge@cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <038d00ad3c402eb0a941b034daecdc3603d82e37.1275925108.git.siccegge@cs.fau.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 09, 2010 at 01:21:30PM +0200, Christoph Egger wrote:

> CONFIG_MTD_PB1550_BOOT, CONFIG_MTD_PB1550_USER doesn't exist in
> Kconfig, therefore removing all references for it from the source
> code.
> 
> Signed-off-by: Christoph Egger <siccegge@cs.fau.de>

Queued for 2.6.26.  When I dug deep in git I didn't want to wait for git
to actually find the last real use of CONFIG_MTD_PB1550_USER - maybe it
was never actually used.

Thanks,

  Ralf
