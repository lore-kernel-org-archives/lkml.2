Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789Ab2JOIwn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 04:52:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58911 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751526Ab2JOIwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 04:52:42 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CA+55aFzu83ktX=ereRACNa6stEU0H5vNxKObUN9bymYCCaHyew@mail.gmail.com>
References: <CA+55aFzu83ktX=ereRACNa6stEU0H5vNxKObUN9bymYCCaHyew@mail.gmail.com> <11002.1350125310@warthog.procyon.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dhowells@redhat.com, paulus@samba.org, davem@davemloft.net,
        jaxboe@fusionio.com, tj@kernel.org, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] UAPI disintegration for include/linux/{,byteorder/}*.h
Date: Mon, 15 Oct 2012 09:52:34 +0100
Message-ID: <13906.1350291154@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> In the meantime, please fix the fact that "tools/perf" broke.

Hmmm...  I assumed that would've been built by allyesconfig...  Apparently not.

David
