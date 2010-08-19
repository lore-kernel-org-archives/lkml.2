Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732Ab0HSLEM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 07:04:12 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:60254 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035Ab0HSLEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 07:04:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCHv2 2/1] Consolidate CONFIG_DEBUG_STRICT_USER_COPY_CHECKS
Date: Thu, 19 Aug 2010 13:04:11 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-8-generic; KDE/4.3.2; x86_64; ; )
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-parisc@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Helge Deller <deller@gmx.de>
References: <201008181428.45029.arnd@arndb.de> <1282184898-30599-1-git-send-email-sboyd@codeaurora.org> <20100819144719.e690c674.sfr@canb.auug.org.au>
In-Reply-To: <20100819144719.e690c674.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201008191304.11190.arnd@arndb.de>
X-Provags-ID: V02:K0:wG7/lOwKjbbJ7ZmxIFo0FUmGe4rvYksDQ5gvgbr6q1G
 f0IiisXAARA4jh+tn3MWWI5qjUnjGVtqL0P3x90E7Uf81e8jLF
 W/SRTnII3MQfrYFgKo1n2CvJZyeWCmCSchrfzkj70kpJHfEnj/
 gzhgUrcSU/Y6BOQXQjmYScJpfYEgIJEnTr+sFp1cA4lQtIJ/Bt
 5foDd8sed6J4hKVPuat8A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 August 2010, Stephen Rothwell wrote:
>   On Wed, 18 Aug 2010 19:28:18 -0700 Stephen Boyd <sboyd@codeaurora.org> wrote:
> >
> > +config ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS
> > +     def_bool y
> 
> Why not just have
> 
> config ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS
>         bool
> 
> in lib/Kconfig.debug
> 
> and select that in each arch that want it?
> 

Yes, that would be even easier, thanks for the suggestion!

	Arnd
