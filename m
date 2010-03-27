Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255Ab0C0N1f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 09:27:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40110 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753087Ab0C0N1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 09:27:34 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <Pine.LNX.4.64.1003262303080.6480@ask.diku.dk>
References: <Pine.LNX.4.64.1003262303080.6480@ask.diku.dk>
To: Julia Lawall <julia@diku.dk>
Cc: dhowells@redhat.com, peterz@infradead.org, mingo@elte.hu,
       tglx@linutronix.de, oleg@redhat.com,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 5/7] arch/powerpc/kernel: Use set_cpus_allowed_ptr
Date: Sat, 27 Mar 2010 13:26:54 +0000
Message-ID: <18162.1269696414@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall <julia@diku.dk> wrote:

> The semantic patch that makes this change is as follows:
> (http://coccinelle.lip6.fr/)

That URL doesn't appear to work:

Not Found
The requested URL /) was not found on this server.
Additionally, a 404 Not Found error was encountered while trying to use an ErrorDocument to handle the request.
Apache/2.2.8 (Mandriva Linux/PREFORK-6mdv2008.1) Server at coccinelle.lip6.fr Port 80

David
