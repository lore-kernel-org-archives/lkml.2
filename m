Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873Ab2IGThz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 15:37:55 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:51738 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755693Ab2IGThx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 15:37:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 12/31] arm64: Atomic operations
Date: Fri, 7 Sep 2012 19:37:47 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com> <1347035226-18649-13-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1347035226-18649-13-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Message-Id: <201209071937.47670.arnd@arndb.de>
X-Provags-ID: V02:K0:DdmguvlkUEOabklBPLLCvjxSk6Ln0EGQFjeP42WEpuJ
 lMajXX5DjmZcFBjCfYGtLuTH9nXvkLvZ+RLJlj1p6uXBFWm/o+
 RbdpBScaWkDV51382IBV6URktE8hpBxkCl7yJb7hkWefPkFyK0
 PdXsd76MKT8X4c7tu1YarUUSLnnBaP2j7bIN5xg0seoTP3QQiE
 nKa8vfyV6SrFTR6wbIPPBaQC812ThojURt8kxBHo+x8XlS1yXC
 7dVWOlARkB1suYPTxQC4q1WHUv7J4s5yTcdnayXrmzb+JXOp2Z
 wPoDclfVPgmOWBUR1tOomyFtXH0TTUy24eZnJFM7ctFmlQ9ND7
 uZWgoI21r5LoAGQIlpIc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 September 2012, Catalin Marinas wrote:
> This patch introduces the atomic, mutex and futex operations. Many
> atomic operations use the load-acquire and store-release operations
> which imply barriers, avoiding the need for explicit DMB.
> 
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Acked-by: Tony Lindgren <tony@atomide.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
