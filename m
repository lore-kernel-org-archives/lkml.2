Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201Ab0F2VLg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 17:11:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18390 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756020Ab0F2VLe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 17:11:34 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <201006292307.42440.bernd.schubert@fastmail.fm>
References: <201006292307.42440.bernd.schubert@fastmail.fm> <20100629200259.23196.81509.stgit@warthog.procyon.org.uk>
To: Bernd Schubert <bernd.schubert@fastmail.fm>
Cc: dhowells@redhat.com, viro@zeniv.linux.org.uk, smfrench@gmail.com,
       jlayton@redhat.com, mcao@us.ibm.com, aneesh.kumar@linux.vnet.ibm.com,
       linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, samba-technical@lists.samba.org,
       sjayaraman@suse.de, linux-ext4@vger.kernel.org
Subject: Re: [PATCH 0/3] Extended file stat functions
Date: Tue, 29 Jun 2010 22:11:19 +0100
Message-ID: <24517.1277845879@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bernd Schubert <bernd.schubert@fastmail.fm> wrote:

> Is there any chance we can use that chance and also add a field 
> 
> unsigned long long st_gen
> 
> to struct_ xstat? Inode generation numbers really would be useful for 
> userspace NFS servers and some fuse filesystems.

That would be st_inode_version (equivalent to i_generation internally).

David
