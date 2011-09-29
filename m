Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331Ab1I2AOl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 20:14:41 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:45966 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057Ab1I2AOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 20:14:39 -0400
Date: Thu, 29 Sep 2011 10:14:24 +1000
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Cc: James Morris <jmorris@namei.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        dhowells@redhat.com, Greg KH <greg@kroah.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>
Subject: Re: [RFC v2.1 0/6] evm: digital signature verification extension
Message-ID: <20110929001424.GA17356@gondor.apana.org.au>
References: <cover.1315921427.git.dmitry.kasatkin@intel.com> <1316525069.3189.4.camel@localhost.localdomain> <CALLzPKbPM-7Z4UphWvZUFxT9vF8XJSWyeUGTkLaM7--2A6y7eA@mail.gmail.com> <alpine.LRH.2.00.1109270914480.4126@tundra.namei.org> <CALLzPKa=DuhmTZ7enLH6LNKA1mimC9OJZoaCJrprrHJwg=mRdQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALLzPKa=DuhmTZ7enLH6LNKA1mimC9OJZoaCJrprrHJwg=mRdQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 28, 2011 at 06:37:34PM +0300, Kasatkin, Dmitry wrote:
> On Tue, Sep 27, 2011 at 2:15 AM, James Morris <jmorris@namei.org> wrote:
> > On Mon, 26 Sep 2011, Kasatkin, Dmitry wrote:
> >
> >> It seems nobody wants to share their thoughts about it?
> >> Does this silence mean acceptance?
> >> Should I prepare final patches for merge?
> >
> > Not yet.
> >
> > I'd like to hear what the crypto folk think about the crypto.
> >
> > --
> > James Morris
> > <jmorris@namei.org>
> >
> 
> Herbert,
> 
> Can you say what you think?

Well if James is OK with adding the user for this then I'm fine
with adding the necessary infrastructure.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
