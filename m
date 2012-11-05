Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933402Ab2KEWxq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 17:53:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6375 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101Ab2KEWxo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 17:53:44 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <15094.1352155791@warthog.procyon.org.uk>
References: <15094.1352155791@warthog.procyon.org.uk>
Cc: dhowells@redhat.com, mingo@kernel.org, tglx@linutronix.de,
        acme@ghostprotocols.net, bp@alien8.de, namhyung@gmail.com,
        torvalds@linux-foundation.org, paulus@samba.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: tools, perf: Fix up for x86 UAPI disintegration
Date: Mon, 05 Nov 2012 22:53:27 +0000
Message-ID: <25722.1352156007@warthog.procyon.org.uk>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> I've posted a revised version of my perf patches to my UAPI disintegration GIT
> tree.

Hmmm...  It seems to break some things according to Fengguang's kbuild test
robot.

David
