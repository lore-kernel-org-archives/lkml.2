Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757959Ab1K3RAS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 12:00:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47850 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757888Ab1K3RAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 12:00:13 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <4ED64B8B.1050806@canonical.com>
References: <4ED64B8B.1050806@canonical.com> <20111129234258.13625.21153.stgit@warthog.procyon.org.uk> <20111129234323.13625.34554.stgit@warthog.procyon.org.uk>
To: Serge Hallyn <serge.hallyn@canonical.com>
Cc: dhowells@redhat.com, keyrings@linux-nfs.org, linux-crypto@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry.kasatkin@intel.com, zohar@linux.vnet.ibm.com,
        arjan.van.de.ven@intel.com, alan.cox@intel.com
Subject: Re: [PATCH 02/16] MPILIB: Add a missing ENOMEM check [ver #2]
Date: Wed, 30 Nov 2011 17:00:01 +0000
Message-ID: <21008.1322672401@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge Hallyn <serge.hallyn@canonical.com> wrote:

> >   	p = buffer = kmalloc(n, GFP_KERNEL);
> > +	if (p<  0)
> > +		return NULL;
> 
> Sorry, maybe i'm having a confused morning, but shouldn't this check be for
> p==NULL rather than p<0?

Bah.  You are, of course, right.  Updated for the next version.

David
