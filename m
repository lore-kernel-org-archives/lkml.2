Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670Ab0IAKql (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 06:46:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15385 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752571Ab0IAKqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 06:46:40 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <4C7DF3B7.7010305@snapgear.com>
References: <4C7DF3B7.7010305@snapgear.com> <4C7B59E1.6010904@snapgear.com> <20100827015905.27277.39167.stgit@warthog.procyon.org.uk> <20100827020038.27277.27239.stgit@warthog.procyon.org.uk> <26799.1283201411@redhat.com>
To: Greg Ungerer <gerg@snapgear.com>
Cc: dhowells@redhat.com, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 18/22] Fix M68K irqflags
Date: Wed, 01 Sep 2010 11:46:25 +0100
Message-ID: <2281.1283337985@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Greg Ungerer <gerg@snapgear.com> wrote:

> -#define local_save_flags(x) asm volatile ("movew %%sr,%0":"=d" (x) : :
> "memory")
> -#define local_irq_restore(x) asm volatile ("movew %0,%%sr": :"d" (x) :
> "memory")

Your patch got partially word-wrapped.

David
