Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159Ab2JHIpd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 04:45:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52046 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383Ab2JHIp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 04:45:28 -0400
Date: Mon, 8 Oct 2012 16:45:44 +0800
From: Wang YanQing <udknight@gmail.com>
To: Borislav Petkov <bp@alien8.de>, mmarek@suse.cz,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        rdunlap@xenotime.net, yann.morin.1998@free.fr, sakiwit@gmail.com,
        lacombar@gmail.com, lucas.demarchi@profusion.mobi, dave@gnu.org,
        paul.gortmaker@windriver.com, crquan@gmail.com, bpoirier@suse.de
Subject: Re: [PATCH v3]mconf: Add Save button
Message-ID: <20121008084544.GA1695@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	Borislav Petkov <bp@alien8.de>, mmarek@suse.cz,
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
	rdunlap@xenotime.net, yann.morin.1998@free.fr, sakiwit@gmail.com,
	lacombar@gmail.com, lucas.demarchi@profusion.mobi, dave@gnu.org,
	paul.gortmaker@windriver.com, crquan@gmail.com, bpoirier@suse.de
References: <20121008050513.GA22078@udknight>
 <20121008060340.GB4148@liondog.tnic>
 <20121008072249.GA29113@udknight>
 <20121008082832.GB19783@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121008082832.GB19783@liondog.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2012 at 10:28:32AM +0200, Borislav Petkov wrote:
> On Mon, Oct 08, 2012 at 03:22:49PM +0800, Wang YanQing wrote:
> > With one terminal, I can do:
> > 1: make menuconfig
> > 2: ajust and use "Save" button to save .config
> > 3: use CRTL-Z(konsole) to "menuconfig" run in background
> > 3: make && test kernel
> > 4: fg or "%1" to resume the menuconfig
> 
> I understand all that, but why do you think your usecase should be
> in the kernel? I still fail to see its relevance for the majority of
> people.
No, I don't think it is only my usecase. Use fg,CRTL-Z is very normal
in terminal or in vt(console), without save button you have to exit 
menuconfig every time you want to save .config.

By the way,just a quick test, qconfig, xconfig, nconfig all have the
Save button, why do them exist if we follow your opinion?

Thanks.
