Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609Ab0EYJOo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 05:14:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22173 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756410Ab0EYJOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 05:14:42 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100524234250.F158849A56@magilla.sf.frob.com>
References: <20100524234250.F158849A56@magilla.sf.frob.com> <20100522165401.GB19573@redhat.com> <1266280229-18469-1-git-send-email-vapier@gentoo.org> <1274431345-22366-1-git-send-email-vapier@gentoo.org> <20100521162659.GA16193@redhat.com> <20100521183512.4477F40476@magilla.sf.frob.com> <20100522165320.GA19573@redhat.com> <25539.1274711817@redhat.com> <20100524151445.GA6393@redhat.com> 
To: Roland McGrath <roland@redhat.com>
Cc: dhowells@redhat.com, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Frysinger <vapier@gentoo.org>, linux-sh@vger.kernel.org,
       Paul Mundt <lethal@linux-sh.org>,
       uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 1/1] ptrace: PTRACE_GETFDPIC: fix the unsafe usage of child->mm
Date: Tue, 25 May 2010 10:14:12 +0100
Message-ID: <17134.1274778852@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath <roland@redhat.com> wrote:

> The mm pointer is only used by these uncommon ptrace operations

Like PEEKTEXT and POKETEXT?

David
