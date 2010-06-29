Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849Ab0F2UvH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 16:51:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62688 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753174Ab0F2UvD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 16:51:03 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1277843319.4500.17.camel@heimdal.trondhjem.org>
References: <1277843319.4500.17.camel@heimdal.trondhjem.org> <20100629200259.23196.81509.stgit@warthog.procyon.org.uk>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: dhowells@redhat.com, viro@ZenIV.linux.org.uk, smfrench@gmail.com,
       jlayton@redhat.com, mcao@us.ibm.com, aneesh.kumar@linux.vnet.ibm.com,
       linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, samba-technical@lists.samba.org,
       sjayaraman@suse.de, linux-ext4@vger.kernel.org
Subject: Re: [PATCH 0/3] Extended file stat functions
Date: Tue, 29 Jun 2010 21:50:40 +0100
Message-ID: <24172.1277844640@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trond Myklebust <trond.myklebust@fys.uio.no> wrote:

> There has been a lot of interest in allowing the user to specify exactly
> which fields they want the filesystem to return, and whether or not the
> kernel can use cached data or not. The main use is to allow
> specification of a 'stat light' that could help speed up
> "readdir()+multiple stat()" type queries. At last year's Filesystem and
> Storage Workshop, Mark Fasheh actually came up with an initial design:
> 
>    http://www.kerneltrap.com/mailarchive/linux-fsdevel/2009/4/7/5427274
> 
> If we're going to add in a whole new syscall for stat, should we perhaps
> revisit this discussion?

I could certainly absorb that patch.

One further consideration following on from what you said: Is it worth having
an extended getdents() that can return stat data too?  That might be useful
for NFS.

David
