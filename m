Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790Ab1AEJwN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 04:52:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56896 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751514Ab1AEJwL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 04:52:11 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20110104161439.f30ab73c.akpm@linux-foundation.org>
References: <20110104161439.f30ab73c.akpm@linux-foundation.org> <1291978505-29076-1-git-send-email-andy.shevchenko@gmail.com> <20110104152100.29d0da02.akpm@linux-foundation.org> <AANLkTi=FpimZ=KS7Qgf8PyZ5jG4_74UG6vA9V+CX6MYD@mail.gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dhowells@redhat.com, Andy Shevchenko <andy.shevchenko@gmail.com>,
        linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Mimi Zohar <zohar@us.ibm.com>,
        "Serge E. Hallyn" <serge@hallyn.com>, James Morris <jmorris@namei.org>
Subject: Re: [resend][PATCH] fs: use kernel's hex_to_bin() method
Date: Wed, 05 Jan 2011 09:51:56 +0000
Message-ID: <28259.1294221116@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> How does one test this thing?

>From userspace.

David
