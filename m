Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759896Ab0EDP76 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 11:59:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51954 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759663Ab0EDP7z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 11:59:55 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100504154601.GA20291@us.ibm.com>
References: <20100504154601.GA20291@us.ibm.com> <20100504131610.2015.50934.stgit@warthog.procyon.org.uk>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: dhowells@redhat.com, torvalds@osdl.org, akpm@linux-foundation.org,
       paulmck@linux.vnet.ibm.com, keyrings@linux-nfs.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KEYS: Fix RCU handling in key_gc_keyring()
Date: Tue, 04 May 2010 16:58:23 +0100
Message-ID: <5363.1272988703@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn <serue@us.ibm.com> wrote:

> You're obviously being far too kind.  In apparent trend for last night
> I missed the lack of locking here.

You pointed out the wrongness of it - it just wasn't in the way you thought.

David
