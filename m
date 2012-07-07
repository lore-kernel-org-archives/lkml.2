Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751477Ab2GGT3U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 15:29:20 -0400
Received: from shutemov.name ([176.9.204.213]:44103 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751081Ab2GGT3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 15:29:19 -0400
X-Greylist: delayed 461 seconds by postgrey-1.27 at vger.kernel.org; Sat, 07 Jul 2012 15:29:19 EDT
Date: Sat, 7 Jul 2012 22:21:59 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
Message-ID: <20120707192159.GA22960@shutemov.name>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
 <20472.466.594018.973876@pilspetsen.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20472.466.594018.973876@pilspetsen.it.uu.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 07, 2012 at 11:30:58AM +0200, Mikael Pettersson wrote:
> Catalin Marinas writes:
>  > Compilation requires a new aarch64-none-linux-gnu-
>  > toolchain (http://gcc.gnu.org/ml/gcc-patches/2012-05/msg01694.html).
> 
> Where are the corresponding binutils patches?  Without those it's
> impossible for people outside ARM to build the toolchain and kernel.

I guess ARM doesn't want to expose instruction set details before the
time. ;)

-- 
 Kirill A. Shutemov
