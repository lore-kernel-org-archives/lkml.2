Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198Ab2I1IMC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 04:12:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34772 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756973Ab2I1ILv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 04:11:51 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <87lifu3cyg.fsf@rustcorp.com.au>
References: <87lifu3cyg.fsf@rustcorp.com.au> <87bogs492s.fsf@rustcorp.com.au> <87ehlp30pd.fsf@rustcorp.com.au> <5555.1348531649@warthog.procyon.org.uk> <8168.1348650575@warthog.procyon.org.uk> <16088.1348736905@warthog.procyon.org.uk>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: dhowells@redhat.com, herbert@gondor.hengli.com.au, pjones@redhat.com,
        jwboyer@redhat.com, linux-crypto@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        keyrings@linux-nfs.org
Subject: Re: [PATCH 2/2] modules: don't call eu-strip if it doesn't exist.
Date: Fri, 28 Sep 2012 09:11:43 +0100
Message-ID: <27432.1348819903@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell <rusty@rustcorp.com.au> wrote:

> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Acked-by: David Howells <dhowells@redhat.com>
