Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934301Ab2FENiK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 09:38:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44746 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932189Ab2FENiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 09:38:08 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1338896342.4044.117.camel@falcor>
References: <1338896342.4044.117.camel@falcor> <20120522230218.24007.3556.stgit@warthog.procyon.org.uk> <26029.1337960539@redhat.com> <87ipf73lsi.fsf@rustcorp.com.au> <1338814071.4044.19.camel@falcor> <87wr3min4b.fsf@rustcorp.com.au>
To: Rusty Russell <rusty@rustcorp.com.au>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: dhowells@redhat.com, kyle@mcmartin.ca, dmitry.kasatkin@intel.com,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        keyrings@linux-nfs.org, Tim Abbott <tabbott@ksplice.com>
Subject: Re: [PATCH 00/23] Crypto keys and module signing
Date: Tue, 05 Jun 2012 14:37:54 +0100
Message-ID: <18630.1338903474@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> As the signature would be stored as an extended attribute, we wouldn't
> need to pass it.  Unfortunately not all filesystems have xattr support,
> nor do all of the package installation mechanims.  The benefit of
> storing the signature as an extended attribute, however, is that there
> is a consistent mechanism for verifying file data integrity for all
> files, not only ELF.

We also want to be able to do module signature verification with CONFIG_IMA=n.

David
