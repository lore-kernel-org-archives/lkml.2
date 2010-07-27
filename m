Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751905Ab0G0Qwy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 12:52:54 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:39302 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937Ab0G0Qwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 12:52:53 -0400
Date: Tue, 27 Jul 2010 18:52:50 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>, sfr@canb.auug.org.au,
        microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, sparclinux@vger.kernel.org,
        davem@davemloft.net
Subject: Re: [PATCH v3] of: Create asm-generic/of.h and provide default
	of_node_to_nid()
Message-ID: <20100727165250.GB26649@merkur.ravnborg.org>
References: <20100726220405.1550.63442.stgit@angua> <20100726222627.GA23501@merkur.ravnborg.org> <AANLkTikcV3jJUm_My-oK-drudSDz3M2iH1cWhxdt+W1s@mail.gmail.com> <201007271534.01250.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201007271534.01250.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 27, 2010 at 03:34:01PM +0200, Arnd Bergmann wrote:
> On Tuesday 27 July 2010, Grant Likely wrote:
> > > I suggest to go back to v2 of your patch where you use asm-generic/of.h.
> > 
> > Stephen suggested dropping asm-generic/of.h.  I'm happy to do it either way.
> 
> I don't mind adding stuff to asm-generic, but I think in this case it would
> be easier to keep this in linux/of.h because there is nothing wrong with
> all architectures including it.
> 
> Most files in asm-generic are there only for historical reasons, where some
> architectures use them but others don't. IMHO we should use the include/linux
> headers preferred for new stuff though.

Hi Arnd.

Thanks for this explanation. Obviously my previous post
about asm-generic was wrong (as Grant already indicated).

	Sam
