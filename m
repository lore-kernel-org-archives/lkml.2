Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759173Ab1D0UaJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 16:30:09 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49606 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759082Ab1D0UaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 16:30:05 -0400
Date: Wed, 27 Apr 2011 21:29:42 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: catalin.marinas@arm.com, linaro-mm-sig@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org, arnd@arndb.de,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] ARM DMA mapping TODO, v1
Message-ID: <20110427202942.GA17290@n2100.arm.linux.org.uk>
References: <201104212129.17013.arnd@arndb.de> <BANLkTinPbZZS9F1tRCA73fgoD-y__jSfCA@mail.gmail.com> <20110427230344I.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110427230344I.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 11:06:00PM +0900, FUJITA Tomonori wrote:
> On Wed, 27 Apr 2011 10:52:25 +0100
> Catalin Marinas <catalin.marinas@arm.com> wrote:
> 
> > Anyway, we end up with different DMA ops per device via dev_archdata.
> 
> Several architectures already do. What's wrong with the approach for
> arm?

Please read the rest of the thread, where I've already explained the
issue.
