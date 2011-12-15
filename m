Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758282Ab1LOAOz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 19:14:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51379 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753150Ab1LOAOx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 19:14:53 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <87obvdtdwz.fsf@rustcorp.com.au>
References: <87obvdtdwz.fsf@rustcorp.com.au> <87ty56taup.fsf@rustcorp.com.au> <87obvfogc6.fsf@rustcorp.com.au> <8739csq5ac.fsf@rustcorp.com.au> <87boriouwa.fsf@rustcorp.com.au> <20111202184229.21874.25782.stgit@warthog.procyon.org.uk> <20111202184651.21874.57769.stgit@warthog.procyon.org.uk> <2657.1323456206@redhat.com> <30007.1323526114@redhat.com> <26644.1323652900@redhat.com> <21605.1323706287@redhat.com> 
To: Rusty Russell <rusty@ozlabs.org>
Cc: dhowells@redhat.com, keyrings@linux-nfs.org, linux-crypto@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry.kasatkin@intel.com, zohar@linux.vnet.ibm.com,
        arjan.van.de.ven@intel.com, alan.cox@intel.com,
        Jon Masters <jcm@jonmasters.org>
Subject: Re: [PATCH 21/21] MODSIGN: Apply signature checking to modules on module load [ver #3]
Date: Thu, 15 Dec 2011 00:14:31 +0000
Message-ID: <24260.1323908071@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell <rusty@ozlabs.org> wrote:

> > > We can have false positives, but at worst that make us report EINVAL
> > > (bad signature) instead of ENOENT (no signature).
> > 
> > EKEYREJECTED please; that way it's the same as RHEL does now.
> 
> OK, sure (who knew that was there?).

Second paragraph in the description of patch #21:

	These patches have been in use by RHEL and Fedora kernels for years,
	and so have been thoroughly tested.

Further down the description:

	Any module for which the kernel has a key, but which proves to have a
	signature mismatch will not be permitted to load (returning
	EKEYREJECTED).

David
