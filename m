Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934332Ab0EEJcY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 05:32:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53138 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934285Ab0EEJcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 05:32:21 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100505005953.GM2639@linux.vnet.ibm.com>
References: <20100505005953.GM2639@linux.vnet.ibm.com> <20100504131610.2015.50934.stgit@warthog.procyon.org.uk>
To: paulmck@linux.vnet.ibm.com
Cc: dhowells@redhat.com, torvalds@osdl.org, akpm@linux-foundation.org,
       serue@us.ibm.com, keyrings@linux-nfs.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KEYS: Fix RCU handling in key_gc_keyring()
Date: Wed, 05 May 2010 10:31:56 +0100
Message-ID: <21842.1273051916@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> As the guilty party in e7b0a61b7929632d36cf052d9e2820ef0a9c1bfe...  ;-)

Only partially guilty;-)

David
