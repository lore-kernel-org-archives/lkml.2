Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751464Ab0DLMUX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 08:20:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18518 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751340Ab0DLMUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 08:20:19 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100412120330.GA2566@osiris.boeblingen.de.ibm.com>
References: <20100412120330.GA2566@osiris.boeblingen.de.ibm.com> <20100412060609.GA25273@dvomlehn-lnx2.corp.sa.net>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: dhowells@redhat.com, David VomLehn <dvomlehn@cisco.com>,
       to@dvomlehn-lnx2.corp.sa.net, "linux-arch@vger.kernel.org"@cisco.com,
       linux-arch@vger.kernel.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, maint_arch@dvomlehn-lnx2.corp.sa.net
Subject: Re: [PATCH 1/23] Make register values available to panic notifiers
Date: Mon, 12 Apr 2010 13:20:02 +0100
Message-ID: <24979.1271074802@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

> Wouldn't it be much easier to implement panic with an illegal op and let
> the exception handler set up the pt regs structure instead? Just like some
> architectures do that already for warnings.

No, not necessarily.  panic() is varargs.

David
