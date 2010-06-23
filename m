Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516Ab0FWQ6S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 12:58:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62343 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751372Ab0FWQ6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 12:58:17 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1277220206-3559-1-git-send-email-sjayaraman@suse.de>
References: <1277220206-3559-1-git-send-email-sjayaraman@suse.de> <yes>
To: Suresh Jayaraman <sjayaraman@suse.de>
Cc: dhowells@redhat.com, Steve French <smfrench@gmail.com>,
       linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 05/10] cifs: define superblock-level cache index objects and register them
Date: Wed, 23 Jun 2010 17:58:10 +0100
Message-ID: <9720.1277312290@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Jayaraman <sjayaraman@suse.de> wrote:

> Define superblock-level cache index objects (managed by cifsTconInfo
> structs).  Each superblock object is created in a server-level index object
> and in itself an index into which inode-level objects are inserted.
> 
> Currently, the superblock objects are keyed by sharename.

Seems reasonable.  Is there any way you can check that the share you are
looking at on a server is the same as the last time you looked?  Can you
validate the root directory of the share in some way?

David
