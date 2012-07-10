Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510Ab2GJKMw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 06:12:52 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:56123 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753318Ab2GJKMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 06:12:50 -0400
Date: Tue, 10 Jul 2012 11:12:23 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
Message-ID: <20120710101223.GF15120@arm.com>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
 <20472.466.594018.973876@pilspetsen.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20472.466.594018.973876@pilspetsen.it.uu.se>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 07, 2012 at 10:30:58AM +0100, Mikael Pettersson wrote:
> Catalin Marinas writes:
>  > Compilation requires a new aarch64-none-linux-gnu-
>  > toolchain (http://gcc.gnu.org/ml/gcc-patches/2012-05/msg01694.html).
> 
> Where are the corresponding binutils patches?  Without those it's
> impossible for people outside ARM to build the toolchain and kernel.

That's coming soon ;)

-- 
Catalin
