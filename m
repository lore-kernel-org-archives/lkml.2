Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316Ab2G3T6m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 15:58:42 -0400
Received: from mail.skyhub.de ([78.46.96.112]:34333 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754814Ab2G3T6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 15:58:30 -0400
Date: Mon, 30 Jul 2012 21:58:26 +0200
From: Borislav Petkov <bp@alien8.de>
To: Benjamin Poirier <bpoirier@suse.de>
Cc: Michal Marek <mmarek@suse.cz>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Arnaud Lacombe <lacombar@gmail.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH 0/6] menuconfig: jump to search results
Message-ID: <20120730195826.GA8242@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Benjamin Poirier <bpoirier@suse.de>, Michal Marek <mmarek@suse.cz>,
	Lucas De Marchi <lucas.demarchi@profusion.mobi>,
	Arnaud Lacombe <lacombar@gmail.com>, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>
References: <1343676130-29770-1-git-send-email-bpoirier@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1343676130-29770-1-git-send-email-bpoirier@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2012 at 03:22:04PM -0400, Benjamin Poirier wrote:
> Hello,
> 
> This patch series adds "jump to" keys (similar to the cscope interface) to the
> search results of "make menuconfig" so that we can go directly to the menu
> entry for a config option after searching for it.
> 
> Patches 1-4 implement the basic functionnality.
> Patches 5-6 are an optionnal improvement.

Generally,

a nice idea, I like it.

A couple of notes though:

* patches 2/6 and 3/6 don't have commit messages and it would be good if
they had, even though it is obvious what the changes in there do.

* this patchset must be against some kbuild tree because it doesn't
apply against 3.5:

$ patch -p1 --dry-run -i ~/0001-menuconfig_extend_dialog_textbox_so_that_it_can_exit_on_arbitrary_keypresses.patch
patching file scripts/kconfig/lxdialog/dialog.h
patching file scripts/kconfig/lxdialog/textbox.c
Hunk #3 FAILED at 132.
Hunk #4 succeeded at 157 (offset -1 lines).
Hunk #5 succeeded at 172 (offset -1 lines).
Hunk #6 succeeded at 252 (offset -3 lines).
Hunk #7 succeeded at 261 (offset -3 lines).
1 out of 7 hunks FAILED -- saving rejects to file scripts/kconfig/lxdialog/textbox.c.rej
patching file scripts/kconfig/mconf.c

Thanks.

-- 
Regards/Gruss,
    Boris.
