Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965328Ab2CGWmq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 17:42:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50424 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965280Ab2CGWmj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 17:42:39 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1331156636.12805.18.camel@deneb.redhat.com>
References: <1331156636.12805.18.camel@deneb.redhat.com> <1331155726.12805.16.camel@deneb.redhat.com> <20120307194548.15987.36073.stgit@warthog.procyon.org.uk> <20120307194725.15987.99209.stgit@warthog.procyon.org.uk> <18700.1331156191@redhat.com>
To: Mark Salter <msalter@redhat.com>
Cc: dhowells@redhat.com, paul.gortmaker@windriver.com, hpa@zytor.com,
        torvalds@linux-foundation.org, sfr@canb.auug.org.au, mingo@redhat.com,
        arnd@arndb.de, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH 08/29] Disintegrate asm/system.h for C6X
Date: Wed, 07 Mar 2012 22:42:19 +0000
Message-ID: <20518.1331160139@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Salter <msalter@redhat.com> wrote:

> Kbuild takes care of it. See arch/c6x/include/Kbuild for the generic
> headers C6X uses as-is.

I'm still not clear on how that actually works.  Does it copy the headers to
asm/ from asm-generic/?

David
