Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742Ab2IGTHa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 15:07:30 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:63507 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab2IGTH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 15:07:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 02/31] arm64: Kernel booting and initialisation
Date: Fri, 7 Sep 2012 19:07:21 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com> <1347035226-18649-3-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1347035226-18649-3-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Message-Id: <201209071907.21615.arnd@arndb.de>
X-Provags-ID: V02:K0:q9MLOVZ8sFKdIpU2oU9+cfcljUBQ7eV8soCdwwvo+6M
 KlnlnGs22EbftOibvd+dTkoO/cwOiqT7Xg4LXE6vV0xD/EqQva
 zu8NjO+KDKt5unB8J5HST4QUGG5wXysFdv2nQdMxaQHYtS+QRb
 ULey+4v47t10qUqtN5C3je7pZUXXWd/ir8xhNaZY35HYBf6Lel
 bdvVxFBKQPz/ueHjd/ahkMzIgTS2geGdW6UCz8dWJ1WSMXitcA
 EaiUpo5KDE13UMZwMv33hyA6qbXxlpcPTCEoltbqpX94aMkXqW
 moY6OgoGShV6YauDAN2sGHhQgGirChFX+Z+UjcZttsJRffvbNd
 LDPSOabKKn8KVV2PHAHo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 September 2012, Catalin Marinas wrote:
> 
> The patch adds the kernel booting and the initial setup code.
> Documentation/arm64/booting.txt describes the booting protocol on the
> AArch64 Linux kernel. This is subject to change following the work on
> boot standardisation, ACPI.
> 
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Acked-by: Nicolas Pitre <nico@linaro.org>
> Acked-by: Tony Lindgren <tony@atomide.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
