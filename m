Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870Ab2AQUkj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 15:40:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13678 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755469Ab2AQUke (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 15:40:34 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.LRH.2.00.1201171037420.12160@tundra.namei.org>
References: <alpine.LRH.2.00.1201171037420.12160@tundra.namei.org> <20120116160349.10775.92195.stgit@warthog.procyon.org.uk>
To: James Morris <jmorris@namei.org>
Cc: dhowells@redhat.com, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KEYS: Add missing smp_rmb() primitives to the keyring search code
Date: Tue, 17 Jan 2012 20:40:29 +0000
Message-ID: <14964.1326832829@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Morris <jmorris@namei.org> wrote:

> > Add missing smp_rmb() primitives to the keyring search code.
> > 
> 
> Does this need to go into 3.3 and stable?

Both.  I've resent the patch plus a couple of others that also need to go into
both.

David
