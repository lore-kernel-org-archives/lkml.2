Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991Ab2KSWXP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 17:23:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54786 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752492Ab2KSWXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 17:23:14 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <50A9EB89.70901@linux.vnet.ibm.com>
References: <50A9EB89.70901@linux.vnet.ibm.com> <50A48912.20606@linux.vnet.ibm.com> <1378.1352379110@warthog.procyon.org.uk> <CA+5PVA5vMyNmQYCLX315Jc+kN9zQuZo_h0Devpjfr43TezE-qA@mail.gmail.com> <18065.1352820271@warthog.procyon.org.uk> <CA+5PVA6qaxCzr8RBV616D3kEXyj9XjS3okeZXhJJL1R4+-Yv_A@mail.gmail.com> <20121113163458.GA1023@ghostprotocols.net> <50A488DD.6090106@linux.vnet.ibm.com> <6764.1352976414@warthog.procyon.org.uk>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: dhowells@redhat.com, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Josh Boyer <jwboyer@gmail.com>, mingo@kernel.org,
        haodong@linux.vnet.ibm.com, runzhen@linux.vnet.ibm.com,
        dsahern@gmail.com, tglx@linutronix.de, bp@alien8.de,
        namhyung@gmail.com, torvalds@linux-foundation.org, paulus@samba.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH 2/2] perf kvm: fix building perf kvm on PowerPC
Date: Mon, 19 Nov 2012 22:22:45 +0000
Message-ID: <5344.1353363765@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com> wrote:

> Yes, thanks for you point it out, David! How about this one?
> 
> Subject: [PATCH 2/2] perf kvm: fix building perf kvm on PowerPC
> 
> Now, 'perf kvm stat' is only supported on x86, let its code depend
> on ARCH_X86 to fix building it on other architectures
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>

Reviewed-by: David Howells <dhowells@redhat.com>
