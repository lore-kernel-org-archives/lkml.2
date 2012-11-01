Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988Ab2KAHnO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 03:43:14 -0400
Received: from ozlabs.org ([203.10.76.45]:39533 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753752Ab2KAHnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 03:43:09 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Josh Boyer <jwboyer@redhat.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] MODSIGN: Add modules_sign make target
In-Reply-To: <20121031135605.GJ6627@hansolo.jdub.homelinux.org>
References: <20121031135605.GJ6627@hansolo.jdub.homelinux.org>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Thu, 01 Nov 2012 18:03:18 +1030
Message-ID: <87zk314w1t.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Josh Boyer <jwboyer@redhat.com> writes:

> If CONFIG_MODULE_SIG is set, and 'make modules_sign' is called then this
> patch will cause the modules to get a signature appended.  The make target
> is intended to be run after 'make modules_install', and will modify the
> modules in-place in the installed location.  It can be used to produce
> signed modules after they have been processed by distribution build
> scripts.
>
> Signed-off-by: Josh Boyer <jwboyer@redhat.com>

It's a bit of a niche case, but applied.

Cheers,
Rusty.
