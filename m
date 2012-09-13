Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755809Ab2IMKsc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 06:48:32 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:65382 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168Ab2IMKs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 06:48:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 26/31] arm64: Miscellaneous library functions
Date: Thu, 13 Sep 2012 10:48:22 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com> <201209071952.14309.arnd@arndb.de> <20120912211259.GA8252@arm.com>
In-Reply-To: <20120912211259.GA8252@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209131048.22385.arnd@arndb.de>
X-Provags-ID: V02:K0:6a4EtwHjX+cGB4oWVL31jQxA86oPU0mNZR8qz98V25t
 gg89Slh11j1ynVGYpe2jnIl2bn5Qjn9kCjtViulO3nWZI2Latl
 kGFNVEC0Ah/HETj0UMnni1GNbIuVBeE9XVRkJO/wj6GAWDXuDb
 pcXF1NjcMI9SejbZ7gkQAXZ0AiPijRDX8MO+qjK+Zq24rRP+ai
 osTwU9UMlfOouLGoDn25FeYhi567bcPUz2l+1Z5rMOdp1Wv2pJ
 SE1oFKfD4wPwGVO+8/M1Wk4aCQKdHsA0Eici6w62lirVcM5Awr
 mfB9EthR6ddRb9I1ZGAKMl4PRkpwqEhjROldFH/UwN8GfqpKim
 APQwAUAfkB9XzbCPWTPU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 September 2012, Catalin Marinas wrote:
> From 64ec78a2fce931e0148db90747c69688f248a531 Mon Sep 17 00:00:00 2001
> From: Catalin Marinas <catalin.marinas@arm.com>
> Date: Wed, 12 Sep 2012 22:00:53 +0100
> Subject: [PATCH 1/2] Implement generic ffs/fls using __builtin_* functions
> 
> This patch implements ffs, __ffs, fls, __fls using __builtin_* gcc
> functions. These header files can be used by other architectures that
> rely on the gcc builtins.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Arnd Bergmann <arnd@arndb.de>

Very good.

Acked-by: Arnd Bergmann <arnd@arndb.de>
