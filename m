Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502Ab0FWRHr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 13:07:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34413 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954Ab0FWRHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 13:07:46 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1277220261-3717-1-git-send-email-sjayaraman@suse.de>
References: <1277220261-3717-1-git-send-email-sjayaraman@suse.de> <yes>
To: Suresh Jayaraman <sjayaraman@suse.de>
Cc: dhowells@redhat.com, Steve French <smfrench@gmail.com>,
       linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 09/10] cifs: read pages from FS-Cache
Date: Wed, 23 Jun 2010 18:07:40 +0100
Message-ID: <9918.1277312860@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Jayaraman <sjayaraman@suse.de> wrote:

> Read pages from a FS-Cache data storage object into a CIFS inode.
> 
> Signed-off-by: Suresh Jayaraman <sjayaraman@suse.de>

Acked-by: David Howells <dhowells@redhat.com>
