Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573Ab2HOPLP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 11:11:15 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:52400 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362Ab2HOPLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 11:11:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v2 25/31] arm64: Performance counters support
Date: Wed, 15 Aug 2012 15:11:11 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com> <1344966752-16102-26-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1344966752-16102-26-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Message-Id: <201208151511.11612.arnd@arndb.de>
X-Provags-ID: V02:K0:vv7UGPk6DCGbf6RqGU2Zwv5SLFUrU6wmqgzGJ4FBsa9
 RVOXtcR72rZd+E7EFO9HprskYLsYVLZgZSK0iYYU17ZodnNaBh
 /+gEuKvhivDOuHRjzx4bjr6cs9A2zfsuRqsid5R9POQqigq0fd
 ZhOpcx3J08zg8GNZsNQgFuwYOVJ6Pi4SRtkSPtXeV0TB7+06fT
 oa/FvmhKt7tUhC2d8tGN1zVgb92ixCLAh38NtWDKnhiLyqUrX1
 c+lFG7tvFS1RWDbs8xua3k8LzY16UfJ4DQw0csYUiyjTt/KMU5
 3HuJ9jgINHCz8kC49rPrFMuWc3GYaCuHKARWzzhXzmDKlbiKdM
 WCCI6hlBCz/RMlB3rY4o=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 August 2012, Catalin Marinas wrote:
> From: Will Deacon <will.deacon@arm.com>
> 
> This patch adds support for the AArch64 performance counters.
> 
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> ---
>  arch/arm64/include/asm/perf_event.h |   22 +
>  arch/arm64/include/asm/pmu.h        |   82 +++
>  arch/arm64/kernel/perf_event.c      | 1368 +++++++++++++++++++++++++++++++++++
>  tools/perf/perf.h                   |    6 +

Can you explain how AArch64 performance counters differ from the 32
bit ones? Do they work for AArch32 user space under AArch64 kernels?
Is it possible to share parts of the implementation with arch/arm?

	Arnd
