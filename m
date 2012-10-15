Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577Ab2JOTYf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 15:24:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23203 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827Ab2JOTYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 15:24:33 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20121015160027.28348.35065.stgit@localhost.localdomain>
References: <20121015160027.28348.35065.stgit@localhost.localdomain> <20121015155800.28348.23561.stgit@localhost.localdomain>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: dhowells@redhat.com, akpm@linux-foundation.org, catalin.marinas@arm.com,
        will.deacon@arm.com, manfred@colorfullife.com, hughd@google.com,
        jmorris@namei.org, mtk.manpages@gmail.com,
        kosaki.motohiro@jp.fujitsu.com, paulmck@linux.vnet.ibm.com,
        sds@tycho.nsa.gov, devel@openvz.org, a.p.zijlstra@chello.nl,
        cmetcalf@tilera.com, linux-driver@qlogic.com, ron.mercer@qlogic.com,
        viro@zeniv.linux.org.uk, eparis@parisplace.org, tglx@linutronix.de,
        jitendra.kalsaria@qlogic.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        ebiederm@xmission.com, casey@schaufler-ca.com
Subject: Re: [PATCH v6 10/10] test: IPC message queue copy feture test
Date: Mon, 15 Oct 2012 20:23:26 +0100
Message-ID: <19575.1350329006@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanislav Kinsbursky <skinsbursky@parallels.com> wrote:

> +CFLAGS += -I../../../../arch/x86/include/generated/
> +CFLAGS += -I../../../../include/
> +CFLAGS += -I../../../../usr/include/
> +CFLAGS += -I../../../../arch/x86/include/

Do you need to add uapi/ into some of these?

David
