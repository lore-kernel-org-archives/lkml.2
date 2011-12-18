Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049Ab1LRVN5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 16:13:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36650 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751968Ab1LRVN4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 16:13:56 -0500
Date: Sun, 18 Dec 2011 22:13:52 +0100
From: Michal Marek <mmarek@suse.cz>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Richard Weinberger <richard@nod.at>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Foley <pefoley2@verizon.net>
Subject: Re: [PATCH] kconfig: adapt update-po-config to new UML layout
Message-ID: <20111218211352.GD25931@sepie.suse.cz>
References: <1320492090.14409.321.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320492090.14409.321.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 05, 2011 at 12:21:30PM +0100, Paul Bolle wrote:
> Commit 5c48b108 ("um: take arch/um/sys-x86 to arch/x86/um") broke the
> make target update-po-config, as its symlink trick (again) fails.
> (Previous breakage was fixed with commit bdc69ca4 ("kconfig: change
> update-po-config to reflect new layout of arch/um").)
> 
> The new UML layout allows to drop the symlick trick entirely. And if,
> one day, another architecture supports UML too, that should now work
> without again breaking this make target.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Thanks, applied to kbuild.git#rc-fixes.

Michal
