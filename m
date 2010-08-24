Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458Ab0HXT7G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 15:59:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55423 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752803Ab0HXT7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 15:59:04 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <4C73F25D.5010205@suse.com>
References: <4C73F25D.5010205@suse.com>
To: Jeff Mahoney <jeffm@suse.com>
Cc: dhowells@redhat.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH] s390: Fix prototype for execve
Date: Tue, 24 Aug 2010 20:58:54 +0100
Message-ID: <4102.1282679934@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Mahoney <jeffm@suse.com> wrote:

>  Commit d7627467b7a8dd6944885290a03a07ceb28c10eb constified the
>  arguments to execve but missed the s390 prototype.
> 
>  This patch fixes it up.
> 
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> Cc: David Howells <dhowells@redhat.com>
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

Acked-by: David Howells <dhowells@redhat.com>
