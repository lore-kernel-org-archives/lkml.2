Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155Ab1DLHgE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 03:36:04 -0400
Received: from mtoichi14.ns.itscom.net ([219.110.2.184]:58518 "EHLO
	mtoichi14.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434Ab1DLHgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 03:36:02 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
cc: linux-kernel@vger.kernel.org
Subject: O_EXCL in NFSv3
Date: Tue, 12 Apr 2011 16:35:33 +0900
Message-ID: <20361.1302593733@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello Trond,

The commit in v2.6.37
	c0204fd 2010-09-17 NFS: Clean up nfs4_proc_create()
looks totally dropping O_EXCL flag from NFSv3.
But fs/nfs/nfs3proc.c:nfs3_proc_create() and
fs/nfsd/nfs3proc.c:nfsd3_proc_create() still expect O_EXCL to be passed.

And the commit log says "Clean up nfs4_proc_create()".
Is this change for NFSv3 intentional?
Actually O_EXCL in NFSv3 doesn't work in v2.6.37 and later.


J. R. Okajima
