Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933281Ab1JDWCS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 18:02:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36290 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933049Ab1JDWCR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 18:02:17 -0400
Date: Wed, 5 Oct 2011 00:02:16 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kernel.org status: establishing a PGP web of trust
In-Reply-To: <20111004125134.GB2803@osiris.boeblingen.de.ibm.com>
Message-ID: <alpine.LNX.2.00.1110050000380.31654@pobox.suse.cz>
References: <4E8655CD.90107@zytor.com> <alpine.LRH.2.00.1110031316260.14853@twin.jikos.cz> <20111004125134.GB2803@osiris.boeblingen.de.ibm.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Oct 2011, Heiko Carstens wrote:

> > I have a question here. In case people are 'reasonably certain' that the 
> > old key has never been jeoparadized, why are they required to create a new 
> > key?
> > 
> > (if the old key would have been compromised, the attacker could as well 
> > generate a new key and sign it with the old key himself, so I fail to see 
> > any benefit of this PGP excercise).
> > 
> > It doesn't make too much sense to force people to live with two different 
> > personalities in this "PGP web of trust" world just for the sake of 
> > kernel.org, does it?
> 
> Also same question here. And as far as I can tell nobody has given an
> answer yet.

In the meantime, at least one reason came up in parallel discussion ... a 
lot of people have those oldish keys generated as 1024bit or so, and using 
DSA.

And it seems like 4096/RSA is sort of required here.

-- 
Jiri Kosina
SUSE Labs
