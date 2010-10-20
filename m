Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846Ab0JTSLa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 14:11:30 -0400
Received: from imr4.ericy.com ([198.24.6.8]:46424 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751681Ab0JTSL3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 14:11:29 -0400
From: Jon Maloy <jon.maloy@ericsson.com>
To: Neil Horman <nhorman@tuxdriver.com>
CC: Leandro Lucarella <luca@llucax.com.ar>, David Miller <davem@davemloft.net>,
        "paul.gortmaker@windriver.com" <paul.gortmaker@windriver.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tipc-discussion@lists.sourceforge.net" 
	<tipc-discussion@lists.sourceforge.net>
Date: Wed, 20 Oct 2010 14:10:51 -0400
Subject: RE: Linux 2.6.35/TIPC 2.0 ABI breaking changes
Thread-Topic: Linux 2.6.35/TIPC 2.0 ABI breaking changes
Thread-Index: ActwgVOFm80Lj0fuSKSc23NQoZjomgAABITw
Message-ID: <0434463FDA60A94FA978ACA44617682DEE846681B9@EUSAACMS0702.eamcs.ericsson.se>
References: <4CBCD429.8090306@windriver.com>
 <20101018234547.GA5703@hmsreliant.think-freely.org>
 <20101019021657.GZ8781@llucax.com.ar>
 <20101019.011649.71113115.davem@davemloft.net>
 <20101019110452.GA14410@hmsreliant.think-freely.org>
 <20101019131936.GB8781@llucax.com.ar>
 <20101019201841.GC14410@hmsreliant.think-freely.org>
 <20101020172018.GN8781@llucax.com.ar>
 <0434463FDA60A94FA978ACA44617682DEE84668199@EUSAACMS0702.eamcs.ericsson.se>
 <20101020180454.GC14407@hmsreliant.think-freely.org>
In-Reply-To: <20101020180454.GC14407@hmsreliant.think-freely.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<...>
> > 
> > Remember, permitting both is a superset of the current one 
> (NBO only) 
> > so it is fully backwards compatible. We break absolutly nothing by 
> > permitting this.
> > 
> Thats effectively reverting both our patches though, isn't it 
> (not that I'm disagreeing with it, just looking for 
> clarification).  If we revert my patch and reintroduce the 
> htohl mechanism which tracks endianess, we might as well 
> revert the TIPC_SUB_SERVICE flag as well, yeah?

Absolutely. I think it was a mistake to change that value.
But I don't think we need to reintroduce the htohl(). That
was just one way of doing it. If I understood your suggestion
from yesterday correctly you converted the whole message within
one if()clause, without any htohl(). I have have no problem with 
that approach.

///jon

> 
> Neil
> 
> > 
> > > 
> > > [1] http://tipc.sourceforge.net/doc/draft-spec-tipc-06.html
> > > [2] 
> http://tipc.sourceforge.net/doc/draft-spec-tipc-06.html#anchor92
> > > 
> > > -- 
> > > Leandro Lucarella (AKA luca)                     
> http://llucax.com.ar/
> > > 
> --------------------------------------------------------------------
> > > -- GPG Key: 5F5A8D05 (F8CD F9A7 BF00 5431 4145  104C 949E 
> BFB6 5F5A 
> > > 8D05)
> > > 
> --------------------------------------------------------------------
> > > -- CARANCHO OBNUBILADO APARECE EN PARQUE CHACABUCO!
> > > 	-- Crónica TV
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe 
> netdev" in 
> > > the body of a message to majordomo@vger.kernel.org More majordomo 
> > > info at  http://vger.kernel.org/majordomo-info.html
> > > --
> > To unsubscribe from this list: send the line "unsubscribe 
> netdev" in 
> > the body of a message to majordomo@vger.kernel.org More 
> majordomo info 
> > at  http://vger.kernel.org/majordomo-info.html
> > 
> 