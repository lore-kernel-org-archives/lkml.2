Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757234Ab2CSKtO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 06:49:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10586 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753133Ab2CSKtM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 06:49:12 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <4F6698C1.3070105@snapgear.com>
References: <4F6698C1.3070105@snapgear.com> <4F608A15.9030609@snapgear.com> <20120312233602.13888.27659.stgit@warthog.procyon.org.uk> <20120312233816.13888.142.stgit@warthog.procyon.org.uk> <17434.1331905343@redhat.com>
To: Greg Ungerer <gerg@snapgear.com>
Cc: dhowells@redhat.com, paul.gortmaker@windriver.com, hpa@zytor.com,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, arnd@arndb.de, linux-m68k@vger.kernel.org
Subject: Re: [PATCH 13/35] Disintegrate asm/system.h for M68K [ver #2]
Date: Mon, 19 Mar 2012 10:49:01 +0000
Message-ID: <4774.1332154141@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Ungerer <gerg@snapgear.com> wrote:

> > How about if I insert the attached patch prior?
> 
> Yep, that fixes it. Builds on its own, and with the asm/system.h
> disintegration patch applied (and rejects fixed) as well.

Can I add your Acked-by to them?

David
