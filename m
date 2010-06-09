Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758279Ab0FIUx4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 16:53:56 -0400
Received: from chipmunk.wormnet.eu ([195.195.131.226]:40640 "EHLO
	chipmunk.wormnet.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755824Ab0FIUxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 16:53:55 -0400
Date: Wed, 9 Jun 2010 21:39:29 +0100
From: Alexander Clouter <alex@digriz.org.uk>
To: Dmytro Milinevskyy <milinevskyy@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org,
       Russell King <linux@arm.linux.org.uk>,
       Dhaval Vasa <dhaval.vasa@einfochips.com>,
       Lennert Buytenhek <kernel@wantstofly.org>,
       Nicolas Pitre <nico@fluxnic.net>, Simon Guinot <sguinot@lacie.com>,
       Martin Michlmayr <tbm@cyrius.com>,
       Simon Kagstrom <simon.kagstrom@netinsight.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Marvell OpenRD-Ultimate machine support
Message-ID: <20100609203929.GL7660@chipmunk>
References: <4c0ff6b2.0c3ddf0a.2185.2e09@mx.google.com> <20100609203720.GK7660@chipmunk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100609203720.GK7660@chipmunk>
Organization: diGriz
X-URL: http://www.digriz.org.uk/
X-JabberID: alex@digriz.org.uk
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

* Alexander Clouter <alex@digriz.org.uk> [2010-06-09 21:37:20+0100]:
>
> >  	kirkwood_ge00_init(&openrd_ge00_data);
> > -	if (machine_is_openrd_client())
> > +	if (machine_is_openrd_client() ||      \__same line
> > +		machine_is_openrd_ultimate())  /
> >  		kirkwood_ge01_init(&openrd_ge01_data);
> > +  <------- REMOVE
> >  	kirkwood_sata_init(&openrd_sata_data);
> >  	kirkwood_sdio_init(&openrd_mvsdio_data);
> >  
> As that 'if()' clause is still less than 77 chars wide:
> ----
> kirkwood_ge00_init(&openrd_ge00_data);
> if (machine_is_openrd_client() || machine_is_openrd_ultimate())
> 	kirkwood_ge01_init(&openrd_ge01_data);
> kirkwood_sata_init(&openrd_sata_data);
> kirkwood_sdio_init(&openrd_mvsdio_data);
> ----
> 
Better still, just make this 'if(!machine_is_openrd_base())'.

Cheers

-- 
Alexander Clouter
.sigmonster says: What this country needs is a good five cent microcomputer.
