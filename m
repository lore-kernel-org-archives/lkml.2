Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914Ab1DSHW6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 03:22:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49312 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974Ab1DSHW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 03:22:57 -0400
Date: Tue, 19 Apr 2011 09:22:54 +0200
From: Michal Marek <mmarek@suse.cz>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Roman Zippel <zippel@linux-m68k.org>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, Nir Tzachar <nir.tzachar@gmail.com>
Subject: Re: [PATCH] nconfig: Silence unused return values from wattrset
Message-ID: <20110419072254.GA13661@sepie.suse.cz>
References: <1302127669-15272-1-git-send-email-sboyd@codeaurora.org>
 <4DACBD80.9080705@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DACBD80.9080705@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 18, 2011 at 03:38:56PM -0700, Stephen Boyd wrote:
> On 04/06/2011 03:07 PM, Stephen Boyd wrote:
> > Ignore the return value from wattrset since we ignore the return
> > value in nconf.gui.c as well.
> >
> > scripts/kconfig/nconf.c: In function 'print_function_line':
> > scripts/kconfig/nconf.c:376: warning: value computed is not used
> > scripts/kconfig/nconf.c:380: warning: value computed is not used
> > scripts/kconfig/nconf.c:387: warning: value computed is not used
> > scripts/kconfig/nconf.c: In function 'show_menu':
> > scripts/kconfig/nconf.c:956: warning: value computed is not used
> > scripts/kconfig/nconf.c:961: warning: value computed is not used
> > scripts/kconfig/nconf.c:963: warning: value computed is not used
> > scripts/kconfig/nconf.c:965: warning: value computed is not used
> >
> > Cc: Nir Tzachar <nir.tzachar@gmail.com>
> > Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> > ---
> 
> Ping? Nack? Ack?

Sorry, I missed this patch. I applied it do kbuild-2.6.git#kconfig now.

Michal
