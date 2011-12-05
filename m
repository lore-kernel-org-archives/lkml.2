Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192Ab1LELVp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 06:21:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8290 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756022Ab1LELVm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 06:21:42 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1323014582.7454.121.camel@deadeye>
References: <1323014582.7454.121.camel@deadeye> <20111129234258.13625.21153.stgit@warthog.procyon.org.uk> <20111129234348.13625.33435.stgit@warthog.procyon.org.uk>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: dhowells@redhat.com, keyrings@linux-nfs.org, linux-crypto@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry.kasatkin@intel.com, zohar@linux.vnet.ibm.com,
        arjan.van.de.ven@intel.com, alan.cox@intel.com
Subject: Re: [PATCH 04/16] PGP: Add definitions (RFC 4880) and packet parser [ver #2]
Date: Mon, 05 Dec 2011 11:21:26 +0000
Message-ID: <32725.1323084086@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Hutchings <ben@decadent.org.uk> wrote:

> I'm a little uneasy about these structure definitions.  There have been
> C ABIs that set the structure alignment to at least 4 by default.  It
> may be better to play safe by declaring them '__packed'.

Yeah.  I'll add that.

David
