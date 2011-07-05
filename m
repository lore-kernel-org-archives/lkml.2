Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467Ab1GEPmd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 11:42:33 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:57782 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478Ab1GEPmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 11:42:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonas Bonn <jonas@southpole.se>
Subject: Re: [PATCH v2 06/19] OpenRISC: PTrace
Date: Tue, 5 Jul 2011 17:42:29 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <1309641352-18714-1-git-send-email-jonas@southpole.se> <1309641352-18714-7-git-send-email-jonas@southpole.se>
In-Reply-To: <1309641352-18714-7-git-send-email-jonas@southpole.se>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201107051742.29359.arnd@arndb.de>
X-Provags-ID: V02:K0:HAWRNhUnN0rZhkTpNvys5s12UUqTn/WBDsUc5RWH362
 UJkJBmATdiuDFwo4bm9tTdTtc1Ijv5guKRhtR/lotpW2LVcZrA
 Y2GBaDUJIw0aatdIj+CkzKmHOCyDJESmsdeBlKm5RYno69ZsxY
 WXeOY10gG69bwbhlqKVfvnJdwRaENnsHFzBZtOnPxf+pCr8ran
 edO1W4XF2YwtoS7wwpVyA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 02 July 2011, Jonas Bonn wrote:
> Signed-off-by: Jonas Bonn <jonas@southpole.se>
> ---
>  arch/openrisc/include/asm/ptrace.h |  124 ++++++++
>  arch/openrisc/kernel/ptrace.c      |  574 ++++++++++++++++++++++++++++++++++++
>  arch/openrisc/kernel/ptrace.h      |   37 +++
>  3 files changed, 735 insertions(+), 0 deletions(-)
>  create mode 100644 arch/openrisc/include/asm/ptrace.h
>  create mode 100644 arch/openrisc/kernel/ptrace.c
>  create mode 100644 arch/openrisc/kernel/ptrace.h

This patch still contains a bunch of commented out code that wants to be
cleaned up. I think you have done that in most other patches that needed
the same cleanup.

	Arnd
