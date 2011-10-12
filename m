Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab1JLUhX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 16:37:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22332 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753842Ab1JLUhW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 16:37:22 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <4E95D1B7.4050603@gmail.com>
References: <4E95D1B7.4050603@gmail.com> <20111012164717.539.44368.stgit@warthog.procyon.org.uk> <20111012164728.539.29820.stgit@warthog.procyon.org.uk>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: dhowells@redhat.com, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] Add assertion checking macros
Date: Wed, 12 Oct 2011 21:36:16 +0100
Message-ID: <4874.1318451776@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby <jirislaby@gmail.com> wrote:

> Hmm, but why not have a single something-like-"ASSERT" doing the same as
> in userspace:

Because I want to print the values that were checked.  Your suggestion merely
turns the unevaluated expression into a string and prints that.  The values
are very useful to know in debugging the problem.

David
