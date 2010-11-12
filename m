Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756972Ab0KLSgk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 13:36:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36883 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932728Ab0KLSgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 13:36:37 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1289583592.4341.58.camel@localhost.localdomain>
References: <1289583592.4341.58.camel@localhost.localdomain> <1289404309-15955-4-git-send-email-zohar@linux.vnet.ibm.com> <1289404309-15955-1-git-send-email-zohar@linux.vnet.ibm.com> <24801.1289580779@redhat.com>
To: David Safford <safford@watson.ibm.com>
Cc: dhowells@redhat.com, Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        keyrings@linux-nfs.org, linux-crypto@vger.kernel.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        James Morris <jmorris@namei.org>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH v1.3 3/4] keys: add new trusted key-type
Date: Fri, 12 Nov 2010 18:36:09 +0000
Message-ID: <25964.1289586969@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Safford <safford@watson.ibm.com> wrote:

> > > +#define TPM_DEBUG 0
> > 
> > The TPM_DEBUG stuff should probably be in the directory with the sources,
> > not in a directory for others to include.
> 
> Maybe some confusion here - trusted_defined.h is in the sources - only
> trusted-type.h is public in include/keys/.

Sorry, you're right.

David
