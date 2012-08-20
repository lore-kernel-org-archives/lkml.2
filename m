Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893Ab2HTUrP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 16:47:15 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:55918 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525Ab2HTUrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 16:47:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v2 08/31] arm64: CPU support
Date: Mon, 20 Aug 2012 20:47:07 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Olof Johansson <olof@lixom.net>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com> <20120815001043.GD19607@quad.lixom.net> <20120820155740.GA912@arm.com>
In-Reply-To: <20120820155740.GA912@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208202047.07991.arnd@arndb.de>
X-Provags-ID: V02:K0:J8LHUiClHyEdObB3QiSkolVIdvGRLhCUPo6ivUY+G9W
 YOIF//D7lBMlue2rh5RtqvOx4Mw4Q5K12zzYpQupWwDwer3fbA
 FNqhm1GRJw72NF1zbao7p9F4NlLaVbaunQjAiexgrYK/EPudG2
 yToa46h6nrmS+hRtaPPAfMSBU3b6QDUx/aHgsPHMKE3A3VF2dg
 WlgUH91C6BiKmbXsUT8rygVzqQ5PmpJR+60Hg6YqCLFzqZ+63g
 et1YQ1XugY95So893KOxEgRyUuqhC20E6yhoDElmeXJkA8eaCx
 wJ3i7f4wlKl+EQXBAy+Qhg7XFDoKA6uUGUybwt/JTbeOsj+xNY
 Nbiv2sZLJZgZTBk9uBxs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 20 August 2012, Catalin Marinas wrote:
> > > --- /dev/null
> > > +++ b/arch/arm64/mm/proc-syms.c
> ...
> > > +EXPORT_SYMBOL(__cpuc_flush_kern_all);
> > > +EXPORT_SYMBOL(__cpuc_flush_user_all);
> > > +EXPORT_SYMBOL(__cpuc_flush_user_range);
> > > +EXPORT_SYMBOL(__cpuc_coherent_kern_range);
> > > +EXPORT_SYMBOL(__cpuc_flush_dcache_area);
> > 
> > See comment on other email about putting function pointers in a struct
> > instead.
> 
> There is no need to support multiple CPU architectures with different
> implementations, so allowing these functions to be called without
> indirection is better.

What is the __cpuc prefix about then? Could you just drop it?

	Arnd
