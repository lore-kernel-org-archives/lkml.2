Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab0IVRoO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 13:44:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32556 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753973Ab0IVRoN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 13:44:13 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <25759.1285169592@redhat.com>
References: <25759.1285169592@redhat.com> <1283888517.23280.241.camel@Joe-Laptop> <23323.1283864982@redhat.com> <20100907180025.GD2662@shadowen.org>
To: Joe Perches <joe@perches.com>
Cc: dhowells@redhat.com, Andy Whitcroft <apw@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: Re: checkpatch problem
Date: Wed, 22 Sep 2010 18:43:56 +0100
Message-ID: <4013.1285177436@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


David Howells <dhowells@redhat.com> wrote:

> Works for me.

Having said that, I now see:

WARNING: Logging function has unnecessary whitespace before a newline
#967: FILE: arch/mn10300/kernel/smp.c:56:
+#define Dprintk(fmt, ...) printk(fmt, ##__VA_ARGS__)

WARNING: Logging function has unnecessary whitespace before a newline
#967: FILE: arch/mn10300/kernel/smp.c:56:
+#define Dprintk(fmt, ...) printk(fmt, ##__VA_ARGS__)

WARNING: Logging function has unnecessary whitespace before a newline
#967: FILE: arch/mn10300/kernel/smp.c:56:
+#define Dprintk(fmt, ...) printk(fmt, ##__VA_ARGS__)

WARNING: Logging function has unnecessary whitespace before a newline
#967: FILE: arch/mn10300/kernel/smp.c:56:
+#define Dprintk(fmt, ...) printk(fmt, ##__VA_ARGS__)

David
