Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760272Ab2C3Mdy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 08:33:54 -0400
Received: from static.78-46-68-141.clients.your-server.de ([78.46.68.141]:33104
	"HELO eristoteles.iwoars.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1752907Ab2C3Mds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 08:33:48 -0400
Date: Fri, 30 Mar 2012 14:33:46 +0200 (CEST)
From: Joel Reardon <joel@clambassador.com>
X-X-Sender: joel@eristoteles.iwoars.net
To: Artem Bityutskiy <dedekind1@gmail.com>
cc: Matthieu CASTET <matthieu.castet@parrot.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] UBI: allow atomic updates to sychronously erase old
 PEB
In-Reply-To: <1333110503.5440.24.camel@sauron.fi.intel.com>
Message-ID: <alpine.DEB.2.00.1203301433270.10066@eristoteles.iwoars.net>
References: <alpine.DEB.2.00.1203291653210.912@eristoteles.iwoars.net>  <4F748CD6.4080704@parrot.com>  <alpine.DEB.2.00.1203301413080.10066@eristoteles.iwoars.net> <1333110503.5440.24.camel@sauron.fi.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just for 'blocking', or also all the 'erase's.

cheers,
Joel Reardon

On Fri, 30 Mar 2012, Artem Bityutskiy wrote:

> On Fri, 2012-03-30 at 14:20 +0200, Joel Reardon wrote:
> > Hey,
> >
> > If there's a power cut after the new version is written and the old one is
> > erased, then it is my understanding that while remounting UBI will detect
> > that the old version is not needed and put it on the erase queue.
>
> Yes.
>
> > The
> > higher layer that issued the call to update the block will have to do a
> > blocking clear of the ubi erase queue when remounting after unsafely
> > unmounting.
>
> Yes. You can do this if the security is enabled, I think, using
> 'ubi_sync()'.
>
> I did not have time to look at your patches, but one quick comment is
> that we usually call the argument which controls whether the function
> has to wait for the operation to complete or not 'sync', could you
> please follow this unwritten convention as well?
>
> --
> Best Regards,
> Artem Bityutskiy
>
