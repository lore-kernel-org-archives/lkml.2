Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758423Ab0GWMGJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 08:06:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16779 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757799Ab0GWMGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 08:06:07 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100723144600.dd4da992.sfr@canb.auug.org.au>
References: <20100723144600.dd4da992.sfr@canb.auug.org.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: dhowells@redhat.com, Tejun Heo <tj@kernel.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Steve French <smfrench@gmail.com>,
        linux-cifs@vger.kernel.org
Subject: Re: linux-next: manual merge of the workqueues tree with the Linus' tree
Date: Fri, 23 Jul 2010 13:05:54 +0100
Message-ID: <19175.1279886754@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Today's linux-next merge of the workqueues tree got a conflict in
> fs/cifs/cifsfs.c between commit 4c0c03ca54f72fdd5912516ad0a23ec5cf01bda7
> ("CIFS: Fix a malicious redirect problem in the DNS lookup code") from
> Linus' tree and commit 9b646972467fb5fdc677f9e4251875db20bdbb64 ("cifs:
> use workqueue instead of slow-work") from the workqueues tree.
> 
> I fixed it up (I think - I removed the call to cifs_exit_dns_resolver()
> as there is no way to get to that code any more) and can carry the fix
> for a while.

Looks right.

David
