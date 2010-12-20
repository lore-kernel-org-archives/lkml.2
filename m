Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932878Ab0LTQvj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 11:51:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21230 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932868Ab0LTQvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 11:51:38 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.LFD.2.00.1012200017280.10437@xanadu.home>
References: <alpine.LFD.2.00.1012200017280.10437@xanadu.home> <alpine.LFD.2.00.1012142219240.10437@xanadu.home> <AANLkTik8Jd4Q4xVZqTCw=gMP6z_ZLv=nn+zN2tVLfi1M@mail.gmail.com>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] clarify a usage constraint for cnt32_to_63()
Date: Mon, 20 Dec 2010 16:51:30 +0000
Message-ID: <21293.1292863890@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Pitre <nico@fluxnic.net> wrote:

> The cnt32_to_63 algorithm relies on proper counter data evaluation
> ordering to work properly. This was missing from the provided
> documentation.
> 
> Let's augment the documentation with the missing usage constraint and
> fix the only instance that got it wrong.
> 
> Signed-off-by: Nicolas Pitre <nico@fluxnic.net>
> Cc: David Howells <dhowells@redhat.com>

Seems to work on my ASB2305.

Acked-by: David Howells <dhowells@redhat.com>

