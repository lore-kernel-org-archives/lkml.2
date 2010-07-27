Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764Ab0G0NeH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 09:34:07 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:63634 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975Ab0G0NeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 09:34:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH v3] of: Create asm-generic/of.h and provide default of_node_to_nid()
Date: Tue, 27 Jul 2010 15:34:01 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-8-generic; KDE/4.3.2; x86_64; ; )
Cc: Grant Likely <grant.likely@secretlab.ca>, Sam Ravnborg <sam@ravnborg.org>,
        sfr@canb.auug.org.au, microblaze-uclinux@itee.uq.edu.au,
        linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
        sparclinux@vger.kernel.org, davem@davemloft.net
References: <20100726220405.1550.63442.stgit@angua> <20100726222627.GA23501@merkur.ravnborg.org> <AANLkTikcV3jJUm_My-oK-drudSDz3M2iH1cWhxdt+W1s@mail.gmail.com>
In-Reply-To: <AANLkTikcV3jJUm_My-oK-drudSDz3M2iH1cWhxdt+W1s@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007271534.01250.arnd@arndb.de>
X-Provags-ID: V02:K0:IBu03tMCrotrfv58q6VhAxWy6NWdy8x590R0lIvxmRU
 Z91qdqBgpGXTqQ3hsK846vZT/uPPOQP49NIjEv7ce2pk+28bZX
 dYVqPAyboFjOtFjV/brv/k0QgyQOpfPkp5CkwheAGBKnZrFyJU
 KZ9Al2KZ/cFP/ecO8ruekepPC8ApLVea88IQMomvtQmbuRjKcV
 aJCPBPLyWAPCP8zlP6Hqw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 July 2010, Grant Likely wrote:
> > I suggest to go back to v2 of your patch where you use asm-generic/of.h.
> 
> Stephen suggested dropping asm-generic/of.h.  I'm happy to do it either way.

I don't mind adding stuff to asm-generic, but I think in this case it would
be easier to keep this in linux/of.h because there is nothing wrong with
all architectures including it.

Most files in asm-generic are there only for historical reasons, where some
architectures use them but others don't. IMHO we should use the include/linux
headers preferred for new stuff though.

	Arnd
