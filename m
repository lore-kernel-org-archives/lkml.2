Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662Ab0FWRFR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 13:05:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1689 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751804Ab0FWRFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 13:05:13 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1277220228-3635-1-git-send-email-sjayaraman@suse.de>
References: <1277220228-3635-1-git-send-email-sjayaraman@suse.de> <yes>
To: Suresh Jayaraman <sjayaraman@suse.de>
Cc: dhowells@redhat.com, Steve French <smfrench@gmail.com>,
       linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 07/10] cifs: FS-Cache page management
Date: Wed, 23 Jun 2010 18:05:01 +0100
Message-ID: <9866.1277312701@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Jayaraman <sjayaraman@suse.de> wrote:

> Takes care of invalidation and release of FS-Cache marked pages and also
> invalidation of the FsCache page flag when the inode is removed.
> 
> Signed-off-by: Suresh Jayaraman <sjayaraman@suse.de>

Acked-by: David Howells <dhowells@redhat.com>
