Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167Ab0DUKsO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 06:48:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54915 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754044Ab0DUKsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 06:48:12 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100421012749.GA21338@us.ibm.com>
References: <20100421012749.GA21338@us.ibm.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: dhowells@redhat.com, lkml <linux-kernel@vger.kernel.org>,
       Ashwin Ganti <ashwin.ganti@gmail.com>, Greg KH <greg@kroah.com>,
       rsc@swtch.com, ericvh@gmail.com, linux-security-module@vger.kernel.org,
       Ron Minnich <rminnich@gmail.com>, jt.beard@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrew Morgan <morgan@kernel.org>, oleg@us.ibm.com,
       Eric Paris <eparis@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 1/3] p9auth: split core function out of some set*{u,g}id functions
Date: Wed, 21 Apr 2010 11:46:57 +0100
Message-ID: <23079.1271846817@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn <serue@us.ibm.com> wrote:

> +int cred_setresuid(struct cred *new, uid_t ruid, uid_t euid, uid_t suid,
> +		   int force);
> +int cred_setresgid(struct cred *new, gid_t rgid, gid_t egid, gid_t sgid,
> +		   int force);
> +int cred_setfsuid(struct cred *new, uid_t uid, uid_t *old_fsuid);
> +int cred_setfsgid(struct cred *new, gid_t gid, gid_t *old_fsgid);

Can you mark these extern please?

Other than that, these functions should probably be mentioned in
Documentation/credentials.txt.

David
