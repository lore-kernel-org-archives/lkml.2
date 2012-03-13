Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932Ab2CMOL5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 10:11:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58638 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754784Ab2CMOLz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 10:11:55 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20120312233602.13888.27659.stgit@warthog.procyon.org.uk>
References: <20120312233602.13888.27659.stgit@warthog.procyon.org.uk>
Cc: dhowells@redhat.com, paul.gortmaker@windriver.com, hpa@zytor.com,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, arnd@arndb.de
Subject: Re: [RFC][PATCH 00/35] Disintegrate and kill asm/system.h [ver #2]
Date: Tue, 13 Mar 2012 14:11:45 +0000
Message-ID: <3744.1331647905@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> Here are a bunch of patches to disintegrate asm/system.h into a set of
> separate bits to relieve the problem of circular inclusion dependencies.

They can also be found here:

	http://git.kernel.org/?p=linux/kernel/git/dhowells/linux-asm_system.git;a=shortlog;h=refs/heads/split-asm-system_h

David
