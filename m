Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752956Ab2JIGSd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 02:18:33 -0400
Received: from mail.x86-64.org ([217.9.48.20]:35634 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752293Ab2JIGSc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 02:18:32 -0400
Date: Tue, 9 Oct 2012 08:18:18 +0200
From: Borislav Petkov <bp@amd64.org>
To: Tony Luck <tony.luck@intel.com>
Cc: EDAC devel <linux-edac@vger.kernel.org>, X86-ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6] AMD MCE injection improvs
Message-ID: <20121009061818.GB23165@aftab.osrc.amd.com>
References: <1349716293-16723-1-git-send-email-bp@amd64.org>
 <CA+8MBbJw8dQEJK-fXFKkDS0_+Ax6ZxppkmxBK+AGafk1YLcvyQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+8MBbJw8dQEJK-fXFKkDS0_+Ax6ZxppkmxBK+AGafk1YLcvyQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2012 at 04:58:34PM -0700, Tony Luck wrote:
> On Mon, Oct 8, 2012 at 10:11 AM, Borislav Petkov <bp@amd64.org> wrote:
> >  create mode 100644 arch/x86/ras/ras.c
> 
> Overall it looks good - but I'm a bit puzzled by this ras.c file that gets
> created as an empty file in part1, and is still empty at the end of the
> series.
> 
> What is going to go into it?

Yeah, maybe it should be called core.c and all the shared functionality
would go there. I put it there initially for the first patch but I
realize now, we won't need it just yet - I'll drop it.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
