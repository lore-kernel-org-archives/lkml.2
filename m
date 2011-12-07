Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343Ab1LGO3x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 09:29:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755803Ab1LGO3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 09:29:51 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.LRH.2.00.1112061151520.25445@tundra.namei.org>
References: <alpine.LRH.2.00.1112061151520.25445@tundra.namei.org> <4EDCABBD.9020401@intel.com> <20111129234258.13625.21153.stgit@warthog.procyon.org.uk> <776.1323085419@redhat.com>
To: James Morris <jmorris@namei.org>
Cc: dhowells@redhat.com, "H. Peter Anvin" <h.peter.anvin@intel.com>,
        keyrings@linux-nfs.org, alan.cox@intel.com,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        dmitry.kasatkin@intel.com, linux-crypto@vger.kernel.org,
        arjan.van.de.ven@intel.com, Herbert Xu <herbert@gondor.hengli.com.au>
Subject: Re: [Keyrings] [RFC][PATCH 00/16] Crypto keys and module signing [ver #2]
Date: Wed, 07 Dec 2011 14:29:32 +0000
Message-ID: <28095.1323268172@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Morris <jmorris@namei.org> wrote:

> > However, we don't have to include the DSA stuff in the kernel; I can always
> > discard that patch from the upstream-aimed patchset.
> 
> I'd encourage dropping DSA, as there appears to be no legacy justification 
> for its inclusion. 

Okay, done that.

David
