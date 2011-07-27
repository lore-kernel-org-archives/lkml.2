Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597Ab1G0PWz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 11:22:55 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:50910 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496Ab1G0PWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 11:22:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Will Newton <will.newton@gmail.com>
Subject: Re: [PATCH] bitops: Use volatile in generic atomic bitops.
Date: Wed, 27 Jul 2011 17:22:51 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
References: <CAFbHwiQaYeQSwRykhKp57rQ8xLKSst9MXF7YJoQjEm0V+WN4Qw@mail.gmail.com> <201107271628.29532.arnd@arndb.de> <CAFbHwiRUKEuK_88+yfUpiWnRBgGKBTpH2Fm7EpzW-dJSiwhHLA@mail.gmail.com>
In-Reply-To: <CAFbHwiRUKEuK_88+yfUpiWnRBgGKBTpH2Fm7EpzW-dJSiwhHLA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107271722.51179.arnd@arndb.de>
X-Provags-ID: V02:K0:0Q2RwBCANgcEu3q7hb3rIeejKBuMXRa/MfPUQxCK2Ko
 VKop37vJRcSPr2xE7aEyGdOouWZh1hdz1CXS1THxd4iTF9/K5O
 Tvt7+ZbJR081kQFol2XAsBksxAWKtTYQ4yxQ9deFkbVRuKW2WG
 N2s/o7zP45XIbwkK1bL+/GzAHQkIKwvIw78gJatnMcpeZbYQSE
 Gme0Cgmd/dUxF0p5QUvlw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 July 2011, Will Newton wrote:
> Imagination Technologies META, which is a custom in-house
> architecture. No immediate plans to upstream unfortunately. :-/

Ah, interesting. We have a few other DSP architectures lined up
for upstream integration. Let me know when you get there as well.
Is there a git tree available somewhere?

> FWIW I checked all the in-tree architectures and it seems everyone
> else gets this right (although I got a bit lost with tile).

Yes, I think that you get into a lot of other problems if you
mess up the basic synchronization primitives, so they would have
noticed at some point.

	Arnd
