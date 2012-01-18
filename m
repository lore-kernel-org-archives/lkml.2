Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757582Ab2AROBO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 09:01:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13943 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757555Ab2AROBN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 09:01:13 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20120118100354.20549.9321.stgit@warthog.procyon.org.uk>
References: <20120118100354.20549.9321.stgit@warthog.procyon.org.uk>
To: stable@kernel.org
Cc: dhowells@redhat.com, jmorris@namei.org, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH] MPILIB: Add a missing ENOMEM check
Date: Wed, 18 Jan 2012 14:00:22 +0000
Message-ID: <28062.1326895222@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> Add a missing ENOMEM check.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> Acked-by: Mimi Zohar <zohar@us.ibm.com>

Actually, this one doesn't need to go into stable as the code being patched
only went in in this merge window.

David
