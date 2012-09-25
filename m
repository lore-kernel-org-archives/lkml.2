Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757324Ab2IYQDX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 12:03:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12413 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756837Ab2IYQDU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 12:03:20 -0400
Message-ID: <1348588977.22489.55.camel@vespa.frost.loc>
Subject: Re: Wrong system clock vs X.509 date specifiers
From: Tomas Mraz <tmraz@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, rusty@rustcorp.com.au,
        herbert@gondor.hengli.com.au, pjones@redhat.com, jwboyer@redhat.com,
        linux-crypto@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, keyrings@linux-nfs.org
Date: Tue, 25 Sep 2012 18:02:57 +0200
In-Reply-To: <30071.1348587320@warthog.procyon.org.uk>
References: <20120925163037.20ba3f3c@pyramind.ukuu.org.uk>
	 <5555.1348531649@warthog.procyon.org.uk>
	 <21845.1348585794@warthog.procyon.org.uk>
	 <30071.1348587320@warthog.procyon.org.uk>
Organization: 
Content-Type: text/plain; charset="ISO-8859-2"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-09-25 at 16:35 +0100, David Howells wrote: 
> Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
> > Generate a certificate that is valid from a few minutes before the
> > wallclock time. It's a certificate policy question not a kernel hackery
> > one.
> 
> That doesn't seem to be possible with openssl req.  What would you recommend?

You can use openssl ca that allows to set arbitrary start date to
generate selfsigned certs as well (-selfsign option).
-- 
Tomas Mraz
No matter how far down the wrong road you've gone, turn back.
                                              Turkish proverb

