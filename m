Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933446Ab1JDTFA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 15:05:00 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:35568 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932820Ab1JDTE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 15:04:59 -0400
Date: Tue, 4 Oct 2011 21:04:40 +0200
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: James Morris <jmorris@namei.org>
Cc: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        dhowells@redhat.com, Greg KH <greg@kroah.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>
Subject: Re: [RFC v2.1 0/6] evm: digital signature verification extension
Message-ID: <20111004190440.GB23212@gondor.apana.org.au>
References: <cover.1315921427.git.dmitry.kasatkin@intel.com> <1316525069.3189.4.camel@localhost.localdomain> <CALLzPKbPM-7Z4UphWvZUFxT9vF8XJSWyeUGTkLaM7--2A6y7eA@mail.gmail.com> <alpine.LRH.2.00.1109270914480.4126@tundra.namei.org> <CALLzPKa=DuhmTZ7enLH6LNKA1mimC9OJZoaCJrprrHJwg=mRdQ@mail.gmail.com> <20110929001424.GA17356@gondor.apana.org.au> <alpine.LRH.2.00.1109291042290.21622@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1109291042290.21622@tundra.namei.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 10:42:46AM +1000, James Morris wrote:
> On Thu, 29 Sep 2011, Herbert Xu wrote:
> 
> > Well if James is OK with adding the user for this then I'm fine
> > with adding the necessary infrastructure.
> 
> Are you happy with the API?

As there is only one user, we can add whatever we want and fix
it later, as long as the crypto part is exposed to user-space.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
