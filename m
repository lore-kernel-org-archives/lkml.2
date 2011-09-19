Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932481Ab1ISVpH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 17:45:07 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:49638 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755195Ab1ISVpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 17:45:05 -0400
Date: Mon, 19 Sep 2011 23:44:58 +0200
From: Borislav Petkov <bp@amd64.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
        "Rosenfeld, Hans" <Hans.Rosenfeld@amd.com>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        Mike Travis <travis@sgi.com>
Subject: Re: [patch 0/3] x86: cache_info: Bugfix and cleanups AMD_NB related
Message-ID: <20110919214457.GA15223@aftab>
References: <20110723212603.517924252@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110723212603.517924252@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 24, 2011 at 05:46:07AM -0400, Thomas Gleixner wrote:
> The following series fixes a kfree() problem in the cache_info code
> and cleans up the shadow struct mess and gets rid of the atomic
> allocation in the smp function call.
> 
> Thanks,
> 
> 	tglx
> ---
>  include/asm/amd_nb.h         |    6 ++
>  kernel/cpu/intel_cacheinfo.c |  121 ++++++++++++++-----------------------------
>  2 files changed, 47 insertions(+), 80 deletions(-)

/me wonders whatever happened to those?

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
