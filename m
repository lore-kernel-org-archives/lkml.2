Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab1APRv3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 12:51:29 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54907 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061Ab1APRv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 12:51:27 -0500
Date: Sun, 16 Jan 2011 17:51:09 +0000
From: Russell King <rmk@arm.linux.org.uk>
To: Akinobu Mita <akinobu.mita@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH v4 05/24] arm: introduce little-endian bitops
Message-ID: <20110116175109.GC13615@flint.arm.linux.org.uk>
Mail-Followup-To: Akinobu Mita <akinobu.mita@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <1295183333-13802-1-git-send-email-akinobu.mita@gmail.com> <1295183333-13802-6-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295183333-13802-6-git-send-email-akinobu.mita@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 16, 2011 at 10:08:34PM +0900, Akinobu Mita wrote:
> Introduce little-endian bit operations by renaming native ext2 bit
> operations.  The ext2 bit operations are kept as wrapper macros using
> little-endian bit operations to maintain bisectability until the
> conversions are finished.

This looks fine to me - is there any chance we can get this in to mainline
so we can avoid conflicts between this and some patches I'm working on atm
to fix the unsafe UP+SMP kernel combination with ARMs bitops ?

It's doing some stuff which needs to be done anyway (the casting to
unsigned long pointers for the ext2/minix find bit functions) which
otherwise will be duplicated in my patches.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
