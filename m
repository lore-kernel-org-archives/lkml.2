Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757776Ab2JQUC1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 16:02:27 -0400
Received: from mail.x86-64.org ([217.9.48.20]:52626 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757218Ab2JQUCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 16:02:25 -0400
Date: Wed, 17 Oct 2012 22:02:22 +0200
From: Borislav Petkov <bp@amd64.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Tony Luck <tony.luck@intel.com>, X86-ML <x86@kernel.org>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH -v2 3/6] x86, RAS: Convert mce-inject module to debugfs
Message-ID: <20121017200222.GA32230@aftab.osrc.amd.com>
References: <1350399175-14477-1-git-send-email-bp@amd64.org>
 <1350399175-14477-4-git-send-email-bp@amd64.org>
 <m2fw5csytg.fsf@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m2fw5csytg.fsf@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 12:06:35PM -0700, Andi Kleen wrote:
> Borislav Petkov <bp@amd64.org> writes:
> 
> > From: Borislav Petkov <borislav.petkov@amd.com>
> >
> > This is a module which is used for debugging MCE decoding paths so its
> > userspace interface should go to debugfs, where it belongs conceptually.
> >
> > While at it, add a warning to the Kconfig text that this interface is
> > unstable and no userspace scripts should rely all too much on it.
> 
> Nack. You broke mce-test/mce-inject, aka existing userland which is not 
> allowed in Linux.

WTF? Have you actually even looked at the patch?

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
