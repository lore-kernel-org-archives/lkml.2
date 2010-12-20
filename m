Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932555Ab0LTOnd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 09:43:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59118 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752945Ab0LTOnb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 09:43:31 -0500
Date: Mon, 20 Dec 2010 15:43:30 +0100
From: Michal Marek <mmarek@suse.cz>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-kbuild@vger.kernel.org,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] checksyscalls: Fix stand-alone usage
Message-ID: <20101220144329.GA20492@sepie.suse.cz>
References: <alpine.DEB.2.00.1008251221270.22455@ayla.of.borg>
 <20100825133027.GA1745@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100825133027.GA1745@merkur.ravnborg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 25, 2010 at 03:30:27PM +0200, Sam Ravnborg wrote:
> On Wed, Aug 25, 2010 at 12:22:40PM +0200, Geert Uytterhoeven wrote:
> > The usage help in the comments
> >   - refers to the wrong script name,
> >   - doesn't mention that $srctree must be set.
> > 
> > Hence correct the script name, and derive the source tree path from the script
> > path, so we no longer need to rely on $srctree being set by the caller.
> > 
> > Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Acked-by: Sam Ravnborg <sam@ravnborg.org>

Applied to kbuild-2.6.git#kbuild, thanks.

Michal
