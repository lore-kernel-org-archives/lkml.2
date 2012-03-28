Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758135Ab2C1KwY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 06:52:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60557 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753949Ab2C1KwV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 06:52:21 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20120328104607.10417.85745.stgit@warthog.procyon.org.uk>
References: <20120328104607.10417.85745.stgit@warthog.procyon.org.uk>
To: jmorris@namei.org
Cc: dhowells@redhat.com, linux-security-module@vger.kernel.org,
        keyrings@linux-nfs.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/9] KEYS: Use the compat keyctl() syscall wrapper on Sparc64 for Sparc32 compat
Date: Wed, 28 Mar 2012 11:52:14 +0100
Message-ID: <10701.1332931934@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Can you push these to Linus in this merge window, please?

David
