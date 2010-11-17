Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934291Ab0KQLSv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 06:18:51 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:59509 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933515Ab0KQLSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 06:18:50 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 15/20] ARM: LPAE: use phys_addr_t instead of unsigned long for physical addresses
Date: Wed, 17 Nov 2010 12:18:13 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Stephen Boyd <sboyd@codeaurora.org>, Will Deacon <will.deacon@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <1289842829-3027-1-git-send-email-catalin.marinas@arm.com> <20101116193335.GD21926@n2100.arm.linux.org.uk> <AANLkTinDGk2HPg7py9nzsqmM3_AbSG_GJJYwsiMr+wQL@mail.gmail.com>
In-Reply-To: <AANLkTinDGk2HPg7py9nzsqmM3_AbSG_GJJYwsiMr+wQL@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011171218.13910.arnd@arndb.de>
X-Provags-ID: V02:K0:M6C88ZMo9Xnw6axHpBWloGEJmTVrPRmCk/54CddQTyH
 JTZP7WROuggYaIy1AVg07BDWsVhzGFnSffkTQbUU6xy6DUgMiM
 riX5J3rN7K96V5QDh1r5sFqfuJPDsn8ndFxA4/9YzaV7wfxM30
 H6hZJnU7oeteq41D6Dzgwh0NUiu515xh52t18+dqDiyIsjsHU7
 XT68+2fuqQD2ojv2iAC6w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 November 2010, Catalin Marinas wrote:
> >
> > It may make sense to mark it const volatile, as that's the most
> > permissive set of attributes possible (iow, it'll accept any pointer
> > without warning.)  However, might be an idea to check what other
> > arches do.
> 
> The majority of architectures use volatile and a few add both const
> and volatile.
> 
> I usually use the generic headers as reference for function prototypes
> and that's just using volatile without a const (cc'ing Arnd for any
> view on this).

const volatile sounds right here, I can also change the generic header
if we agree to do the same in arm.

	Arnd
