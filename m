Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318Ab2IGT27 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 15:28:59 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:54234 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378Ab2IGT24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 15:28:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 10/31] arm64: TLB maintenance functionality
Date: Fri, 7 Sep 2012 19:28:52 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com> <1347035226-18649-11-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1347035226-18649-11-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Message-Id: <201209071928.52417.arnd@arndb.de>
X-Provags-ID: V02:K0:ZtGQRsokx0x8fOsyq0SC0w7YET+nk6+zKnDT7iuVwz8
 UOH8WRdhdJNqsxEXMygq/HkyluXDbJDr1LYXQsLkIhivRB2tj3
 DHTn9HJlmz5EoKDwweitlKTcQHG0uQzdMQoDcDiRIdS76NUBPn
 4p6jnZ/gks32fJ5/9RVmLIdQGaBC4YcpBECU8YBLXHlbxt/jXr
 M4JoaSWkPWf+cxxAQ1yrse1pShtmG4gaQpC7WxqaqQ5bM8jqAf
 xAKlXK5+Bx7Lg2tD9rKKvRFs+AhnyzFm8GyjP8KADOjRsJ0ET7
 exv+HERsrsTJ+afn60W2eNRhZSaU2QpEtP8F89V0YpZjeX8GJ1
 PU6vLVmX9QDVzzz0fpDs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 September 2012, Catalin Marinas wrote:
> 
> This patch adds the TLB maintenance functions. There is no distinction
> made between the I and D TLBs. TLB maintenance operations are
> automatically broadcast between CPUs in hardware. The inner-shareable
> operations are always present, even on UP systems.
> 
> NOTE: Large part of this patch to be dropped once Peter Z's generic
> mmu_gather patches are merged.
> 
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Acked-by: Tony Lindgren <tony@atomide.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
