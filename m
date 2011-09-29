Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398Ab1I2AnL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 20:43:11 -0400
Received: from tundra.namei.org ([65.99.196.166]:51900 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754081Ab1I2AnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 20:43:08 -0400
Date: Thu, 29 Sep 2011 10:42:46 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Herbert Xu <herbert@gondor.hengli.com.au>
cc: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        dhowells@redhat.com, Greg KH <greg@kroah.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>
Subject: Re: [RFC v2.1 0/6] evm: digital signature verification extension
In-Reply-To: <20110929001424.GA17356@gondor.apana.org.au>
Message-ID: <alpine.LRH.2.00.1109291042290.21622@tundra.namei.org>
References: <cover.1315921427.git.dmitry.kasatkin@intel.com> <1316525069.3189.4.camel@localhost.localdomain> <CALLzPKbPM-7Z4UphWvZUFxT9vF8XJSWyeUGTkLaM7--2A6y7eA@mail.gmail.com> <alpine.LRH.2.00.1109270914480.4126@tundra.namei.org>
 <CALLzPKa=DuhmTZ7enLH6LNKA1mimC9OJZoaCJrprrHJwg=mRdQ@mail.gmail.com> <20110929001424.GA17356@gondor.apana.org.au>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Sep 2011, Herbert Xu wrote:

> Well if James is OK with adding the user for this then I'm fine
> with adding the necessary infrastructure.

Are you happy with the API?


-- 
James Morris
<jmorris@namei.org>
