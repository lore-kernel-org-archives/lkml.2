Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594Ab0FWRDD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 13:03:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30823 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751804Ab0FWRDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 13:03:00 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1277220214-3597-1-git-send-email-sjayaraman@suse.de>
References: <1277220214-3597-1-git-send-email-sjayaraman@suse.de> <yes>
To: Suresh Jayaraman <sjayaraman@suse.de>
Cc: dhowells@redhat.com, Steve French <smfrench@gmail.com>,
       linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 06/10] cifs: define inode-level cache object and register them
Date: Wed, 23 Jun 2010 18:02:53 +0100
Message-ID: <9822.1277312573@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Jayaraman <sjayaraman@suse.de> wrote:

> Define inode-level data storage objects (managed by cifsInodeInfo structs).
> Each inode-level object is created in a super-block level object and is
> itself a data storage object in to which pages from the inode are stored.
> 
> The inode object is keyed by UniqueId. The coherency data being used is
> LastWriteTime and the file size.

Isn't there a file creation time too?

I take it you don't support caching on files that are open for writing at this
time?

David
