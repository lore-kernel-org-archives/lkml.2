Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502Ab0FWQzF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 12:55:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18394 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751794Ab0FWQzB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 12:55:01 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1277220198-3522-1-git-send-email-sjayaraman@suse.de>
References: <1277220198-3522-1-git-send-email-sjayaraman@suse.de> <yes>
To: Suresh Jayaraman <sjayaraman@suse.de>
Cc: dhowells@redhat.com, Steve French <smfrench@gmail.com>,
       linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 04/10] cifs: define server-level cache index objects and register them with FS-Cache
Date: Wed, 23 Jun 2010 17:54:52 +0100
Message-ID: <9658.1277312092@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Jayaraman <sjayaraman@suse.de> wrote:

> Define server-level cache index objects (as managed by TCP_ServerInfo
> structs).  Each server object is created in the CIFS top-level index object
> and is itself an index into which superblock-level objects are inserted.
> 
> Currently, the server objects are keyed by hostname.
> 
> Signed-off-by: Suresh Jayaraman <sjayaraman@suse.de>

Looks reasonable, apart from the index key.  I agree with Jeff that you
probably want {address,port,family} rather than a hostname.

David
