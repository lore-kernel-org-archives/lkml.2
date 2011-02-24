Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248Ab1BXQ7M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 11:59:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46466 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753226Ab1BXQ7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 11:59:09 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20110224150243.GE8262@mail.hallyn.com>
References: <20110224150243.GE8262@mail.hallyn.com> <20110224150150.GA8262@mail.hallyn.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: dhowells@redhat.com, Andrew Morton <akpm@osdl.org>,
        containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>, oleg@mail.hallyn.com,
        dlezcano@mail.hallyn.com, LSM <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH 05/10] Allow ptrace from non-init user namespaces
Date: Thu, 24 Feb 2011 16:57:56 +0000
Message-ID: <27809.1298566676@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn <serge@hallyn.com> wrote:

> ptrace is allowed to tasks in the same user namespace according to

That's still missing a verb.
