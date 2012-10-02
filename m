Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989Ab2JBQzd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 12:55:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38999 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752678Ab2JBQzb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 12:55:31 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAHkRjk4Nv-Wb6NA9tZkLPQw8NFvTXMScF3x6i=e+KeBC0uF6Dw@mail.gmail.com>
References: <CAHkRjk4Nv-Wb6NA9tZkLPQw8NFvTXMScF3x6i=e+KeBC0uF6Dw@mail.gmail.com> <15670.1349125526@warthog.procyon.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: dhowells@redhat.com, torvalds@osdl.org, arnd@arndb.de, hpa@zytor.com,
        alan@lxorguk.ukuu.org.uk, fengguang.wu@intel.com,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Disintegrate the User API from the kernel headers
Date: Tue, 02 Oct 2012 17:55:11 +0100
Message-ID: <30848.1349196911@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Catalin Marinas <catalin.marinas@arm.com> wrote:

> There is arm64 that got merged, so its headers need splitting as well.
> I'm happy to send a pull request myself just for arm64 if you give me
> the script, otherwise you can run you script again close to -rc1 (and
> I'll test it).

I can just re-run my scripts and post a new set of patches.

David
