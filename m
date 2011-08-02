Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113Ab1HBL7M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 07:59:12 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:36408 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072Ab1HBL7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 07:59:02 -0400
Date: Tue, 2 Aug 2011 13:58:53 +0200
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Tony Luck <tony.luck@intel.com>, EDAC devel <linux-edac@vger.kernel.org>,
        X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] x86, MCE: Use MCE decoder notifier chain
Message-ID: <20110802115853.GC15897@aftab>
References: <1310999086-30870-1-git-send-email-bp@amd64.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310999086-30870-1-git-send-email-bp@amd64.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping?

Mauro, any progress on those below?

Thanks.

On Mon, Jul 18, 2011 at 10:24:44AM -0400, Borislav Petkov wrote:
> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> Hi Mauro, Tony,
> 
> the following two patches convert i7core_edac to use the MCE decoder
> notifier chain, thus getting rid of the custom edac_mce hook. There
> should be no functionality change following from this along with a nice
> diffstat of removing ca 100 lines.
> 
> The patches are ontop of the latest tip/ras/core and are available at
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git fix-mce-logging
> 
> I'd like to ask you guys to please give them a run to make sure I
> haven't broken i7core_edac.
> 
> Thanks.
> 
>  arch/x86/kernel/cpu/mcheck/mce.c |   18 ++++-------
>  drivers/edac/Kconfig             |    3 --
>  drivers/edac/Makefile            |    1 -
>  drivers/edac/edac_mce.c          |   61 --------------------------------------
>  drivers/edac/i7core_edac.c       |   51 +++++++++++++++----------------
>  include/linux/edac_mce.h         |   31 -------------------
>  6 files changed, 31 insertions(+), 134 deletions(-)
> 
> 
> 

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
