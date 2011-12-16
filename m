Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760142Ab1LPQJS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 11:09:18 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:58666 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068Ab1LPQJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 11:09:10 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Eric B Munson <emunson@mgebm.net>
Subject: Re: [PATCH 0/4 V7] Avoid soft lockup message when KVM is stopped by host
Date: Fri, 16 Dec 2011 16:08:57 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: avi@redhat.com, mingo@redhat.com, hpa@zytor.com, ryanh@linux.vnet.ibm.com,
        aliguori@us.ibm.com, mtosatti@redhat.com,
        jeremy.fitzhardinge@citrix.com, levinsasha928@gmail.com,
        Jan Kiszka <jan.kiszka@siemens.com>, kvm@vger.kernel.org,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
References: <1323978126-13222-1-git-send-email-emunson@mgebm.net>
In-Reply-To: <1323978126-13222-1-git-send-email-emunson@mgebm.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201112161608.57532.arnd@arndb.de>
X-Provags-ID: V02:K0:gb13B1MrO8AxdhqKXr74bv4mLGiSbRJ8EtegBA0M9YL
 rSkyCN/CRTeHs0fEeOzkdnOSr2qbOeRDPzYWHqwCN9oFvwGBx9
 pE9dZE4MD2szMQL2BKoOrrALbeXp+CBMtXyUvFAxMdZcysiJw2
 0reN/XE/JBKSpdB7yEkZLPMulWqWf01tKS904jpd+jUpHqkubQ
 XvClZEPoGfgVs+qM8/GnFCXLVnjSN5nN2JtWK82Lo/x/EcAPfS
 2uOnIH7EWIbcXGQD1uX48pGMkEk3IXM86DJtCzgoOWBjTHUYpN
 uU23HeLDw40pQHSKau5/EtTRsK3aXO5362LY76E9xSP6cQApmw
 5orF+lL4SOmOkhk5/1Pw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 December 2011, Eric B Munson wrote:
>  Documentation/virtual/kvm/api.txt   |   12 ++++++++++++
>  arch/ia64/include/asm/kvm_para.h    |    5 +++++
>  arch/powerpc/include/asm/kvm_para.h |    5 +++++
>  arch/s390/include/asm/kvm_para.h    |    5 +++++
>  arch/x86/include/asm/kvm_host.h     |    2 ++
>  arch/x86/include/asm/kvm_para.h     |    8 ++++++++
>  arch/x86/include/asm/pvclock-abi.h  |    1 +
>  arch/x86/kernel/kvmclock.c          |   21 +++++++++++++++++++++
>  arch/x86/kvm/x86.c                  |   20 ++++++++++++++++++++
>  include/asm-generic/kvm_para.h      |   14 ++++++++++++++
>  include/linux/kvm.h                 |    2 ++
>  kernel/watchdog.c                   |   12 ++++++++++++
>  12 files changed, 107 insertions(+), 0 deletions(-)
>  create mode 100644 include/asm-generic/kvm_para.h

asm-generic changes Acked-by: Arnd Bergmann <arnd@arndb.de>

but please remove me from the cc-list for the other patches.

	Arnd
