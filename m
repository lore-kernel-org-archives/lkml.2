Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932083Ab2JPQjK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 12:39:10 -0400
Received: from mail.x86-64.org ([217.9.48.20]:45750 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754742Ab2JPQjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 12:39:08 -0400
Date: Tue, 16 Oct 2012 18:39:06 +0200
From: Borislav Petkov <bp@amd64.org>
To: Joe Perches <joe@perches.com>
Cc: Tony Luck <tony.luck@intel.com>, X86-ML <x86@kernel.org>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH -v2 3/6] x86, RAS: Convert mce-inject module to debugfs
Message-ID: <20121016163905.GD24044@aftab.osrc.amd.com>
References: <1350399175-14477-1-git-send-email-bp@amd64.org>
 <1350399175-14477-4-git-send-email-bp@amd64.org>
 <1350402077.28048.8.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350402077.28048.8.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2012 at 08:41:17AM -0700, Joe Perches wrote:
> On Tue, 2012-10-16 at 16:52 +0200, Borislav Petkov wrote:
> > From: Borislav Petkov <borislav.petkov@amd.com>
> []
> > diff --git a/arch/x86/ras/amd/mce-inject.c b/arch/x86/ras/amd/mce-inject.c
> []
> > +#define MCE_INJECT_GET(reg)						\
> > +static int inj_##reg##_get(void *data, u64 *val)			\
> >  {									\
> > -	return sprintf(buf, "0x%016llx\n", i_mce.reg);			\
> > +	struct mce *m = (struct mce *)data;				\
> 
> trivia: doesn't need a cast

Corrected, thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
