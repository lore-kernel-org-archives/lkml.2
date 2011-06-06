Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756963Ab1FFNuX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 09:50:23 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:37311 "EHLO duck.linux-mips.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756365Ab1FFNuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 09:50:21 -0400
Date: Mon, 6 Jun 2011 14:49:41 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Frank Hofmann <frank.hofmann@tomtom.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-sh@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 2/3] PM / Hibernate: Remove arch_prepare_suspend()
Message-ID: <20110606134941.GB15453@linux-mips.org>
References: <201105211408.28671.rjw@sisk.pl>
 <201105211410.34491.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201105211410.34491.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 21, 2011 at 02:10:34PM +0200, Rafael J. Wysocki wrote:

> 
> All architectures supporting hibernation define
> arch_prepare_suspend() as an empty function, so remove it.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  arch/frv/include/asm/suspend.h       |   20 --------------------
>  arch/mips/include/asm/suspend.h      |    2 --

I don't see what we'd possibly need that hook for so:

Acked-by: Ralf Baechle <ralf@linux-mips.org>

  Ralf
