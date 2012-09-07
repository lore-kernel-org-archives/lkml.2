Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547Ab2IGTLy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 15:11:54 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:55299 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163Ab2IGTLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 15:11:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 06/31] arm64: MMU fault handling and page table management
Date: Fri, 7 Sep 2012 19:11:47 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com> <1347035226-18649-7-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1347035226-18649-7-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Message-Id: <201209071911.48183.arnd@arndb.de>
X-Provags-ID: V02:K0:GIvs14aWlNazazvJFc12SguZNJM/Pr5jxuvPCvdPzAZ
 WoygowTzGwp7W98J0+E2KBSUAHZvAjn1UvA96PvrTyVvRbYV60
 +jpD6X7KIrj8jaW2UmgMldJ1N+lQgiLEqHEG2k3WpxdV2eB3rU
 +1avYJ1qpeWtwLa5bryjTZioMJ6o2i4tSkaic+am5h0Ru9P6VC
 68VOtcauxCAtHuqzzMjhmYcqwx64OzX5eDJOyKuuZ/9dXLuEg1
 iepANoMiRo/UfY6hDaWITq1YrYNMrnicnNTr/WUkpBlnm4wVDz
 hR5HGskSpCL1jkyeG3iRDBS2l6V8u47BqHgg+6ynJWJIznTMRN
 E2qwFIsRE7QERsvrfeBA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 September 2012, Catalin Marinas wrote:
> 
> This patch adds support for the handling of the MMU faults (exception
> entry code introduced by a previous patch) and page table management.
> 
> The user translation table is pointed to by TTBR0 and the kernel one
> (swapper_pg_dir) by TTBR1. There is no translation information shared or
> address space overlapping between user and kernel page tables.
> 
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Acked-by: Tony Lindgren <tony@atomide.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
