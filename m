Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709Ab0JRJ1F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 05:27:05 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33287 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754673Ab0JRJ1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 05:27:03 -0400
Date: Mon, 18 Oct 2010 10:26:50 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 04/22] arm: introduce little endian bitops
Message-ID: <20101018092650.GC26183@n2100.arm.linux.org.uk>
References: <1287135981-17604-1-git-send-email-akinobu.mita@gmail.com> <1287135981-17604-5-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287135981-17604-5-git-send-email-akinobu.mita@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 15, 2010 at 06:46:03PM +0900, Akinobu Mita wrote:
> Introduce little endian bit operations by renaming native ext2 bit
> operations. The ext2 bit operations are kept by using little endian
> bit operations until the conversions are finished.

Can you explain why we need another level of indirection rather than
using asm-generic/bitops/le.h, asm-generic/bitops/minix.h and
asm-generic/bitops/ext2-non-atomic.h ?
