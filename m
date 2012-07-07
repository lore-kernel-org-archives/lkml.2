Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751462Ab2GGJlF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 05:41:05 -0400
Received: from smtp1.uu.se ([130.238.7.54]:52972 "EHLO smtp1.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985Ab2GGJlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 05:41:00 -0400
X-Greylist: delayed 552 seconds by postgrey-1.27 at vger.kernel.org; Sat, 07 Jul 2012 05:41:00 EDT
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <20472.466.594018.973876@pilspetsen.it.uu.se>
Date: Sat, 7 Jul 2012 11:30:58 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
In-Reply-To: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Catalin Marinas writes:
 > Compilation requires a new aarch64-none-linux-gnu-
 > toolchain (http://gcc.gnu.org/ml/gcc-patches/2012-05/msg01694.html).

Where are the corresponding binutils patches?  Without those it's
impossible for people outside ARM to build the toolchain and kernel.

/Mikael
