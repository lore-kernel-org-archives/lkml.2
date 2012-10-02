Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056Ab2JBRLn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 13:11:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18736 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751264Ab2JBRLl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 13:11:41 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CA+55aFyu9rJH0x9eAF7A=m64nSCRtcPxdE4MR3+ZSd8qxEbwFw@mail.gmail.com>
References: <CA+55aFyu9rJH0x9eAF7A=m64nSCRtcPxdE4MR3+ZSd8qxEbwFw@mail.gmail.com> <13458.1349122608@warthog.procyon.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Airlie <airlied@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Cc: dhowells@redhat.com, arnd@arndb.de, hpa@zytor.com,
        alan@lxorguk.ukuu.org.uk, fengguang.wu@intel.com,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Disintegrate the User API from the kernel headers
Date: Tue, 02 Oct 2012 18:11:23 +0100
Message-ID: <8455.1349197883@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> At the KS you said you'd be able to split this up into a preparatory
> patch. That doesn't seem to have happened.

I've been generating a tag at the preparatory patch set point for quite a
while now.  If you look in the tags list on:

	http://git.infradead.org/users/dhowells/linux-headers.git

you will see a number of tags of the form:

	uapi-prep-YYYYMMDD

that's the preparatory set if you want to take just that.

Yesterday's preparatory set is at tag:

	uapi-prep-20121001

See: http://git.infradead.org/users/dhowells/linux-headers.git/shortlog/refs/tags/uapi-prep-20121001

I have just done another regeneration so that arm64 is covered too.  That
has now been posted under:

	uapi-post-split-20121001	- The complete set
	uapi-prep-20121002		- The preparatory set

I will send you a pull request for just the preparatory set when I have tried
some test builds on it and when gitweb has finally caught up.

David
