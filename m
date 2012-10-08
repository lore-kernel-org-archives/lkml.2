Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057Ab2JHI2i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 04:28:38 -0400
Received: from mail.skyhub.de ([78.46.96.112]:40630 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752712Ab2JHI2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 04:28:35 -0400
Date: Mon, 8 Oct 2012 10:28:32 +0200
From: Borislav Petkov <bp@alien8.de>
To: Wang YanQing <udknight@gmail.com>
Cc: mmarek@suse.cz, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        rdunlap@xenotime.net, yann.morin.1998@free.fr, sakiwit@gmail.com,
        lacombar@gmail.com, lucas.demarchi@profusion.mobi, dave@gnu.org,
        paul.gortmaker@windriver.com, crquan@gmail.com, bpoirier@suse.de
Subject: Re: [PATCH v3]mconf: Add Save button
Message-ID: <20121008082832.GB19783@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Wang YanQing <udknight@gmail.com>, mmarek@suse.cz,
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
	rdunlap@xenotime.net, yann.morin.1998@free.fr, sakiwit@gmail.com,
	lacombar@gmail.com, lucas.demarchi@profusion.mobi, dave@gnu.org,
	paul.gortmaker@windriver.com, crquan@gmail.com, bpoirier@suse.de
References: <20121008050513.GA22078@udknight>
 <20121008060340.GB4148@liondog.tnic>
 <20121008072249.GA29113@udknight>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121008072249.GA29113@udknight>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2012 at 03:22:49PM +0800, Wang YanQing wrote:
> With one terminal, I can do:
> 1: make menuconfig
> 2: ajust and use "Save" button to save .config
> 3: use CRTL-Z(konsole) to "menuconfig" run in background
> 3: make && test kernel
> 4: fg or "%1" to resume the menuconfig

I understand all that, but why do you think your usecase should be
in the kernel? I still fail to see its relevance for the majority of
people.

AFAICT, this is only if you want to experiment with different options
but you're better off replicating your .config with the couple options
instead of adding a save button.

IOW, this would only make a distant sense if you were playing with all
kconfig options but why would you want to do that?

Thanks.

-- 
Regards/Gruss,
    Boris.
