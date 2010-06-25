Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233Ab0FYM4E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 08:56:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50162 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752535Ab0FYM4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 08:56:01 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <4C24A606.5040001@suse.de>
References: <4C24A606.5040001@suse.de> <1277220214-3597-1-git-send-email-sjayaraman@suse.de> <yes> <9822.1277312573@redhat.com>
To: Suresh Jayaraman <sjayaraman@suse.de>
Cc: dhowells@redhat.com, Steve French <smfrench@gmail.com>,
       linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 06/10] cifs: define inode-level cache object and register them
Date: Fri, 25 Jun 2010 13:55:49 +0100
Message-ID: <22697.1277470549@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Jayaraman <sjayaraman@suse.de> wrote:

> I think the creation time is currently being ignored as we won't be able
> to accomodate in POSIX stat struct.

The FS-Cache interface doesn't use the POSIX stat struct, but it could be
really useful to save it and use it for cache coherency inside the kernel.

Out of interest, what does Samba do when it comes to generating a creation time
for UNIX where one does not exist?

David
