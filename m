Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731Ab2JHHWg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 03:22:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63899 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883Ab2JHHWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 03:22:34 -0400
Date: Mon, 8 Oct 2012 15:22:49 +0800
From: Wang YanQing <udknight@gmail.com>
To: Borislav Petkov <bp@alien8.de>, mmarek@suse.cz,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        rdunlap@xenotime.net, yann.morin.1998@free.fr, sakiwit@gmail.com,
        lacombar@gmail.com, lucas.demarchi@profusion.mobi, dave@gnu.org,
        paul.gortmaker@windriver.com, crquan@gmail.com, bpoirier@suse.de
Subject: Re: [PATCH v3]mconf: Add Save button
Message-ID: <20121008072249.GA29113@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	Borislav Petkov <bp@alien8.de>, mmarek@suse.cz,
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
	rdunlap@xenotime.net, yann.morin.1998@free.fr, sakiwit@gmail.com,
	lacombar@gmail.com, lucas.demarchi@profusion.mobi, dave@gnu.org,
	paul.gortmaker@windriver.com, crquan@gmail.com, bpoirier@suse.de
References: <20121008050513.GA22078@udknight>
 <20121008060340.GB4148@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121008060340.GB4148@liondog.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2012 at 08:03:40AM +0200, Borislav Petkov wrote:
> Well, there are a bunch of patches from Benjamin Poirier adding the
> possibility to jump to search results and you could use them to go to
> your desired submenu.
First there are two ways to save the .config in menuconfig
1:Exit menuconfig with choice the "Yes" to save .config
2:go to top menu and use the "Save an alternate Configuration File" to save .config

No matter which way you choice, it is slow and annoying to find the origin
submenu where you have interest.The bunch of patches from Benjamin make it
a little annoying, but not ignore it.Just image the situation that you have 
to exit menuconfig then "make menuconfig" and search down the submenu time 
by time, it is really annoying.

> > So I add "Save" button to save our time. With "Save" button, I can use
> > CRTL-Z after save config, and then use "%" or fg to resume menuconfig
> > and go on tuning.
> 
> Ok, IIUC, when you put menuconfig in the background, edit .config by
> hand in the shell and then do 'fg', you need to reload the edited
> .config back otherwise you lose your changes you just did by hand.
> 
> And generally speaking, why exactly do you need to edit .config by hand,
> and, at same time, do it over menuconfig? IMO, with Benjamin's patches,
> you don't need to do that anymore, right?
> 
> Thanks.
It is not the first time to make me trouble with representation by my poor English,
sorry for that.I hope the below words show the really meaning that I want to give you.

With one terminal, I can do:
1: make menuconfig
2: ajust and use "Save" button to save .config
3: use CRTL-Z(konsole) to "menuconfig" run in background
3: make && test kernel
4: fg or "%1" to resume the menuconfig

With two terminal, I can do:
in first terminal
1: make menuconfig 
2: ajust and use "Save" button to save .config

in second terminal
3: make && test kernel

go back the first terminal and go on tuning.

Now, you can see what the "Save" button can do,
it make there is no "exit menuconfig" or go to
the top menu when you want to save .config in 
menuconfig

Thanks!
