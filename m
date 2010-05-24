Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818Ab0EXIiy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 04:38:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31403 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753857Ab0EXIiw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 04:38:52 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Mike Frysinger <vapier@gentoo.org>, linux-sh@vger.kernel.org,
       Paul Mundt <lethal@linux-sh.org>,
       uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>
Subject: Re: [PATCH -mm 1/1] ptrace: PTRACE_GETFDPIC: fix the unsafe usage of
	child->mm
In-Reply-To: Oleg Nesterov's message of  Saturday, 22 May 2010 18:54:01 +0200 <20100522165401.GB19573@redhat.com>
References: <1266280229-18469-1-git-send-email-vapier@gentoo.org>
	<1274431345-22366-1-git-send-email-vapier@gentoo.org>
	<20100521162659.GA16193@redhat.com>
	<20100521183512.4477F40476@magilla.sf.frob.com>
	<20100522165320.GA19573@redhat.com>
	<20100522165401.GB19573@redhat.com>
Emacs: more than just a Lisp interpreter, a text editor as well!
Message-Id: <20100524083818.1A6C649A4D@magilla.sf.frob.com>
Date: Mon, 24 May 2010 01:38:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Roland McGrath <roland@redhat.com>
