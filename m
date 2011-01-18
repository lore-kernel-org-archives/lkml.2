Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502Ab1ARO7t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 09:59:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21814 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751943Ab1ARO7r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 09:59:47 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1295359633-4993-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1295359633-4993-1-git-send-email-zohar@linux.vnet.ibm.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH 1/3] trusted-keys: rename trusted_defined files to trusted
Date: Tue, 18 Jan 2011 14:59:39 +0000
Message-ID: <21676.1295362779@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

>  security/keys/Makefile          |    2 +-
>  security/keys/trusted.c         | 1180 +++++++++++++++++++++++++++++++++++++++
>  security/keys/trusted.h         |  134 +++++
>  security/keys/trusted_defined.c | 1180 ---------------------------------------
>  security/keys/trusted_defined.h |  134 -----
>  5 files changed, 1315 insertions(+), 1315 deletions(-)
>  create mode 100644 security/keys/trusted.c
>  create mode 100644 security/keys/trusted.h
>  delete mode 100644 security/keys/trusted_defined.c
>  delete mode 100644 security/keys/trusted_defined.h

Doesn't GIT have a shorthand way of describing renames in patches?

David
