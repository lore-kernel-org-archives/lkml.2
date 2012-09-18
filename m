Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877Ab2IRW00 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 18:26:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14339 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755629Ab2IRW0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 18:26:22 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <16779.1348005829@warthog.procyon.org.uk>
References: <16779.1348005829@warthog.procyon.org.uk> <13189.1347989652@warthog.procyon.org.uk> <20120914103930.1e16ad8b@pyramind.ukuu.org.uk> <20120913234802.3575.77103.stgit@warthog.procyon.org.uk> <20120913235005.3575.46218.stgit@warthog.procyon.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: dhowells@redhat.com, herbert@gondor.hengli.com.au, pjones@redhat.com,
        rusty@rustcorp.com.au, linux-crypto@vger.kernel.org, zohar@us.ibm.com,
        dmitry.kasatkin@intel.com, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/16] X.509: Add an ASN.1 decoder
Date: Tue, 18 Sep 2012 23:26:04 +0100
Message-ID: <17317.1348007164@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> Also, here's a generator of random binary ASN.1.  I think it should mostly
> produce valid X.509, but invalid ASN.1 is okay too.
> ...
>     $len = 4; #####################

With this line removed, obviously...

David
