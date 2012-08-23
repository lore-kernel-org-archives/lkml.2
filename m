Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932823Ab2HWMsp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 08:48:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11357 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817Ab2HWMsn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 08:48:43 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <50352873.9070706@schaufler-ca.com>
References: <50352873.9070706@schaufler-ca.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: dhowells@redhat.com, LKLM <linux-kernel@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH] Smack: setprocattr memory leak fix
Date: Thu, 23 Aug 2012 13:48:37 +0100
Message-ID: <27988.1345726117@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Schaufler <casey@schaufler-ca.com> wrote:

> From: Casey Schaufler <casey@schaufler-ca.com>
> Subject: [PATCH] Smack: setprocattr memory leak fix
> 
> The data structure allocations being done in prepare_creds
> are duplicated in smack_setprocattr. This results in the
> structure allocated in prepare_creds being orphaned and
> never freed. The duplicate code is removed from
> smack_setprocattr.
> 
> Targeted for git://git.gitorious.org/smack-next/kernel.git
> 
> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>

Acked-by: David Howells <dhowells@redhat.com>

Note that I do have a patch to make Smack share rule lists - I've posted it a
number of times, but I take it you're not interested.

  5707  06/13 [To:casey@schauf]  [PATCH 1/3] Smack: Constify some pointers<<Mak
  5708  06/13   [To:casey@schauf]  [PATCH 2/3] Smack: Further constification<<M
  5709  06/13   [To:casey@schauf]  [PATCH 3/3] Smack: Use rule list tail sharin

David
