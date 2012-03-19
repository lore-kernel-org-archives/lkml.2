Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964973Ab2CSKpa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 06:45:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36717 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753791Ab2CSKp1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 06:45:27 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1331908808.12353.2.camel@deneb.redhat.com>
References: <1331908808.12353.2.camel@deneb.redhat.com> <20120315205514.28759.58969.stgit@warthog.procyon.org.uk> <20120315205603.28759.91855.stgit@warthog.procyon.org.uk>
To: Mark Salter <msalter@redhat.com>
Cc: dhowells@redhat.com, paul.gortmaker@windriver.com,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        arnd@arndb.de, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 05/38] Disintegrate asm/system.h for ARM [ver #3]
Date: Mon, 19 Mar 2012 10:45:11 +0000
Message-ID: <2349.1332153911@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Salter <msalter@redhat.com> wrote:

> Looks like this hunk was unintended. It is causing a build failure for
> me.

Yep.  Removed that already and reissued the ARM chunk, though only on the ARM
list.

David
