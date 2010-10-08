Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932309Ab0JHKYf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 06:24:35 -0400
Received: from canuck.infradead.org ([134.117.69.58]:60982 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932281Ab0JHKYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 06:24:34 -0400
Date: Fri, 8 Oct 2010 06:24:33 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/5] bitops: add generic implementation of ext2 atomic
 bitops by test_and_{set,clear}_bit
Message-ID: <20101008102433.GA24208@infradead.org>
References: <1286532193-29814-1-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286532193-29814-1-git-send-email-akinobu.mita@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 07:03:09PM +0900, Akinobu Mita wrote:
> This introduces asm-generic header file for generic implementation of
> ext2 atomic bit operations by test_and_set_bit() and test_and_clear_bit().
> 
> alpha, arm, cris, frv, ia64, m68k, mn10300, parisc, powerpc, s390,
> sparc64, x86, xtensa can use this header file in its asm/bitops.h.

Care to rename the functions to le_* instead of ext2_* while you're at
it and documenting their semantics?

