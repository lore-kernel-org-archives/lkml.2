Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573Ab2CLNhY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 09:37:24 -0400
Received: from static.78-46-68-141.clients.your-server.de ([78.46.68.141]:42355
	"HELO eristoteles.iwoars.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1755411Ab2CLNhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 09:37:23 -0400
Date: Mon, 12 Mar 2012 14:37:21 +0100 (CET)
From: Joel Reardon <joel@clambassador.com>
X-X-Sender: joel@eristoteles.iwoars.net
To: Artem Bityutskiy <dedekind1@gmail.com>
cc: linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] Adding Secure Deletion to UBIFS
In-Reply-To: <1331559361.12037.29.camel@sauron.fi.intel.com>
Message-ID: <alpine.DEB.2.00.1203121436280.29192@eristoteles.iwoars.net>
References: <alpine.DEB.2.00.1202091615540.26924@eristoteles.iwoars.net>  <1330536308.3545.158.camel@sauron.fi.intel.com>  <alpine.DEB.2.00.1203011434220.2462@eristoteles.iwoars.net>  <1331278562.22872.18.camel@sauron.fi.intel.com> 
 <alpine.DEB.2.00.1203091959570.25737@eristoteles.iwoars.net>  <1331559053.12037.25.camel@sauron.fi.intel.com> <1331559361.12037.29.camel@sauron.fi.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sounds good, I'll use the main git repo and as the first patch I'll claim
those 8 bytes and make key.h reflect whats going on.

Cheers,
Joel

On Mon, 12 Mar 2012, Artem Bityutskiy wrote:

> On Mon, 2012-03-12 at 15:30 +0200, Artem Bityutskiy wrote:
> > >  Btw, when I was
> > > developing it I used the last 8 bytes from the key as the key position,
> > > because the key was 16 bytes but only 8 were used. Could you comment on
> > > the last 8 bytes of ubifs keys?
> >
> > I think you can use them. But is it possible to kill these things from
> > the data nodes themselves? We can always find it by looking up the index
> > by the data node key, right?
>
> Joel, but please, send small patches, preparation patches, etc. Do not
> disappear for several months and do not come back with another big
> patch. Tell about your intentions in advance.
>
> E.g., if you decide to start using those unused 8 bytes - first do small
> preparations like removing the notion of "key scheme" which we
> provisioned but never used (from comments as well). Clean-up the "space"
> for yourself. Then start using them for your purposes. As I said, as
> soon as I get the first patch I like, I'll create a separate branch in
> the UBIFS git tree for your work.
>
> Thanks!
>
> --
> Best Regards,
> Artem Bityutskiy
>
>
