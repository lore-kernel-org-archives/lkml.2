Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759474Ab2EJMWb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 08:22:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57363 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755015Ab2EJMW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 08:22:28 -0400
Date: Thu, 10 May 2012 14:22:27 +0200
From: Michal Marek <mmarek@suse.cz>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Tony Luck <tony.luck@gmail.com>, linux arch <linux-arch@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Richard Weinberger <richard@nod.at>,
        "David S. Miller" <davem@davemloft.net>,
        Arnaud Lacombe <lacombar@gmail.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] kbuild: fix ia64 link
Message-ID: <20120510122227.GB17550@sepie.suse.cz>
References: <20120428205651.GA7426@merkur.ravnborg.org>
 <20120428205919.GC7442@merkur.ravnborg.org>
 <4FA460AB.6060309@suse.cz>
 <20120505082916.GA14006@merkur.ravnborg.org>
 <CA+8MBbKd9zAouJy5JvUnLwUHMJ65HsYgCTfBgv42nm32EnMPFA@mail.gmail.com>
 <20120508165118.GA11750@merkur.ravnborg.org>
 <CA+8MBbJHH1niHHR7md844UwphmeYczYQBJOB3huGFaxU9AXMTA@mail.gmail.com>
 <20120508175346.GA11887@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120508175346.GA11887@merkur.ravnborg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2012 at 07:53:46PM +0200, Sam Ravnborg wrote:
> From aca8f5bd71797534ea220b193772946f59ee8125 Mon Sep 17 00:00:00 2001
> From: Sam Ravnborg <sam@ravnborg.org>
> Date: Tue, 8 May 2012 19:49:59 +0200
> Subject: [PATCH] kbuild: fix ia64 link
> 
> ia64 build failed like this:
> 
>   CC      init/version.o
>   LD      init/built-in.o
>   KSYM    .tmp_kallsyms1.o
> ld: .tmp_kallsyms1.o: linking constant-gp files with non-constant-gp files
> ld: failed to merge target specific data of file .tmp_kallsyms1.o
> make: *** [vmlinux] Error 1
> 
> This was introduced when link of vmlinux was migrated to a script.
> Add missing option to as to fix this.
> 
> Reported-by: Tony Luck <tony.luck@gmail.com>
> Tested-by: Tony Luck <tony.luck@gmail.com>
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> ---
> 
> Hi Michal - please apply.

Done, thanks.

Michal
