Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908Ab2HMPkA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 11:40:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16891 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751040Ab2HMPj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 11:39:59 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1344332473-19842-1-git-send-email-jonas.gorski@gmail.com>
References: <1344332473-19842-1-git-send-email-jonas.gorski@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: dhowells@redhat.com, Jonas Gorski <jonas.gorski@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
Subject: Re: [PATCH] MIPS: fix module.c build for 32 bit
Date: Mon, 13 Aug 2012 16:39:42 +0100
Message-ID: <31154.1344872382@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Rusty,

I've fixed up my patch for ARM and pulled Jonas's patch on top of that.  Do
you want me to merge them together?

David
