Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756765Ab2JITeE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 15:34:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44203 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755201Ab2JITeC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 15:34:02 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20121009183206.GA26104@phenom.dumpdata.com>
References: <20121009183206.GA26104@phenom.dumpdata.com> <30773.1349789452@warthog.procyon.org.uk>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: dhowells@redhat.com, jeremy@goop.org, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Disintegrate UAPI for xen
Date: Tue, 09 Oct 2012 20:33:55 +0100
Message-ID: <7035.1349811235@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:

> What is up with your key?

I'm using a time-limited subkey to sign git tags with, so you may have to pull
my key again to get it.

	warthog>gpg --recv-keys 044B2B3B
	gpg: requesting key 044B2B3B from hkp server pgp.mit.edu
	gpg: key A7CB0B6B: "David Howells <dhowells@redhat.com>" not changed
	gpg: Total number processed: 1
	gpg:              unchanged: 1

David
