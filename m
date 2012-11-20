Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856Ab2KTJxe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 04:53:34 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39400 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751901Ab2KTJxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 04:53:31 -0500
Date: Tue, 20 Nov 2012 10:53:28 +0100
From: Michal Marek <mmarek@suse.cz>
To: Krzysztof Mazur <krzysiek@podlesie.net>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] menuconfig: fix extended colors ncurses support
Message-ID: <20121120095328.GA28431@sepie.suse.cz>
References: <1349713102-3301-1-git-send-email-krzysiek@podlesie.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349713102-3301-1-git-send-email-krzysiek@podlesie.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2012 at 06:18:22PM +0200, Krzysztof Mazur wrote:
> The ncurses library allows for extended colors. The support for extended
> colors support depends on wide-character support. ncurses headers
> enable extended colors (NCURSES_EXT_COLORS) only when wide-character
> support is enabled (NCURSES_WIDECHAR).
> 
> The "make menuconfig" uses wide-character ncursesw library, which can be
> compiled with wide-character support, but does not define NCURSES_WIDECHAR
> and it's using headers without wide-character (and extended colors) support.
> 
> This fixes problems with colors on systems with enabled extended colors
> (like PLD Linux). Without this patch "make menuconfig" is hard to use.
> 
> Signed-off-by: Krzysztof Mazur <krzysiek@podlesie.net>


Applied to kbuild.git#kconfig, thanks.

Michal
