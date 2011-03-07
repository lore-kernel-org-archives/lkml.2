Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954Ab1CGOp4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 09:45:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28256 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751160Ab1CGOpv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 09:45:51 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1299508603.20104.30.camel@Joe-Laptop>
References: <1299508603.20104.30.camel@Joe-Laptop> <20110307113523.24025.37925.stgit@warthog.procyon.org.uk>
To: Joe Perches <joe@perches.com>
Cc: dhowells@redhat.com, mtk.manpages@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: Add a guideline on notification of new userspace API/ABI elements
Date: Mon, 07 Mar 2011 14:45:46 +0000
Message-ID: <27835.1299509146@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches <joe@perches.com> wrote:

> F:	include/*/unistd.h

I think you mean arch/include/*/*unistd*.h and arch/include/*/*seccomp*.h.

David
