Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242Ab2JHGDq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 02:03:46 -0400
Received: from mail.skyhub.de ([78.46.96.112]:59197 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773Ab2JHGDo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 02:03:44 -0400
Date: Mon, 8 Oct 2012 08:03:40 +0200
From: Borislav Petkov <bp@alien8.de>
To: Wang YanQing <udknight@gmail.com>
Cc: mmarek@suse.cz, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        rdunlap@xenotime.net, yann.morin.1998@free.fr, sakiwit@gmail.com,
        lacombar@gmail.com, lucas.demarchi@profusion.mobi, dave@gnu.org,
        paul.gortmaker@windriver.com, crquan@gmail.com, bpoirier@suse.de
Subject: Re: [PATCH v3]mconf: Add Save button
Message-ID: <20121008060340.GB4148@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Wang YanQing <udknight@gmail.com>, mmarek@suse.cz,
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
	rdunlap@xenotime.net, yann.morin.1998@free.fr, sakiwit@gmail.com,
	lacombar@gmail.com, lucas.demarchi@profusion.mobi, dave@gnu.org,
	paul.gortmaker@windriver.com, crquan@gmail.com, bpoirier@suse.de
References: <20121008050513.GA22078@udknight>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121008050513.GA22078@udknight>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2012 at 01:05:14PM +0800, Wang YanQing wrote:
> mconf make me annoying I have to make menuconfig && exit to save the
> config when I am tuning .config time by time, it is even worse I have
> to search down to my desire submenu time by time.

Well, there are a bunch of patches from Benjamin Poirier adding the
possibility to jump to search results and you could use them to go to
your desired submenu.

They're not upstream yet, AFAICT, although Michal applied them.

> So I add "Save" button to save our time. With "Save" button, I can use
> CRTL-Z after save config, and then use "%" or fg to resume menuconfig
> and go on tuning.

Ok, IIUC, when you put menuconfig in the background, edit .config by
hand in the shell and then do 'fg', you need to reload the edited
.config back otherwise you lose your changes you just did by hand.

And generally speaking, why exactly do you need to edit .config by hand,
and, at same time, do it over menuconfig? IMO, with Benjamin's patches,
you don't need to do that anymore, right?

Thanks.

-- 
Regards/Gruss,
    Boris.
