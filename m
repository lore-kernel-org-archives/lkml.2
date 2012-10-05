Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743Ab2JEMyR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 08:54:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1087 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754492Ab2JEMyQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 08:54:16 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <506E092A.6050405@zytor.com>
References: <506E092A.6050405@zytor.com> <17459.1349380319@warthog.procyon.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: dhowells@redhat.com, tglx@linutronix.de, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Disintegrate UAPI for x86
Date: Fri, 05 Oct 2012 13:54:02 +0100
Message-ID: <24355.1349441642@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin <hpa@zytor.com> wrote:

> That branch does have generic patches which are not yet in upstream.  I
> presume that is intentional.

Yeah.  It works better if the generic patches are there first.  I thought that
as long as everyone pulls the same disintegrate-asm-generic branch at the
bottom of their tree, then git merging should work just fine.

OTOH, not everyone is willing to pull their branch in this window, so, if
Linus pulls the prep patches and Arnd pushes the asm-generic bits, then the
lower layers can go away and everyone gets a branch with only their bits on.

David
