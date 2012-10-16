Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910Ab2JPTId (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 15:08:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4807 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753123Ab2JPTIc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 15:08:32 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1350413336.8077.6.camel@dabdike>
References: <1350413336.8077.6.camel@dabdike> <21164.1349774145@warthog.procyon.org.uk>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: dhowells@redhat.com, jejb@parisc-linux.org, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Disintegrate UAPI for parisc [ver #2]
Date: Tue, 16 Oct 2012 20:08:06 +0100
Message-ID: <31900.1350414486@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> I'm getting a fairly massive merge failure over our misc tree:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/parisc-2.0 misc
> 
> It looks like a conflict with the motion to using wrappered Kbuild for
> our asm-generic clones.

I can try merging your branch in and then disintegrating on top of that.

David
