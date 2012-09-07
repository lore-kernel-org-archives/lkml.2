Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794Ab2IGTqt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 15:46:49 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:51168 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887Ab2IGTqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 15:46:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 20/31] arm64: User access library functions
Date: Fri, 7 Sep 2012 19:46:43 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com> <1347035226-18649-21-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1347035226-18649-21-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Message-Id: <201209071946.44184.arnd@arndb.de>
X-Provags-ID: V02:K0:wXIADUxyUP3r0S6r+4TzAiHOGsANVJW5ATUA8eULXEe
 giNi2ZUEvYHlmxX3qPlXH9eD0Bh07irlzNUGXV3BrHSXPY9y7i
 i0l9VOb5rpTERjSvcUaNICFthrvoCJF5+N3yHrIHCQp1phSb3F
 BP22tzkefjtTgzDRDVgHcONEUvhyAnNDkakctG1jncF9HYGawH
 2SWqEi+emb7DLO6iB/13uXEvcOuQOW7G3TdPp4va/fkAoe0ToI
 PCVyNDNc38BNXqV8pFYNpeajJvU8v6va3AmBM+cjlvz/3AU9QB
 JvPTty0q165A0H/k7Emrl50RBRU/s1rL222TNO+wBu54nIdkbc
 Icvi2NJ9XDsMREcFAkaI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 September 2012, Catalin Marinas wrote:
> This patch add support for various user access functions. These
> functions use the standard LDR/STR instructions and not the LDRT/STRT
> variants in order to allow kernel addresses (after set_fs(KERNEL_DS)).
> 
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Acked-by: Tony Lindgren <tony@atomide.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
