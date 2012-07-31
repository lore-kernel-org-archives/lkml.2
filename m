Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202Ab2GaSoa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 14:44:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39033 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755656Ab2GaSo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 14:44:28 -0400
Date: Tue, 31 Jul 2012 11:44:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mgorman@suse.de>
Cc: "Myklebust, Trond" <Trond.Myklebust@netapp.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeff Layton <jlayton@redhat.com>
Subject: Re: linux-next: manual merge of the akpm tree with the nfs tree
Message-Id: <20120731114426.029644e0.akpm@linux-foundation.org>
In-Reply-To: <20120731175022.GU612@suse.de>
References: <20120731142441.0d01100f9d050ec6e479c923@canb.auug.org.au>
	<20120731103336.GN612@suse.de>
	<1343745442.519.20.camel@lade.trondhjem.org>
	<20120731151936.GR612@suse.de>
	<1343748906.5528.17.camel@lade.trondhjem.org>
	<20120731175022.GU612@suse.de>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jul 2012 18:50:22 +0100
Mel Gorman <mgorman@suse.de> wrote:

> Stephen Rothwell reported a merge conflict between a MM patch "nfs:
> enable swap on NFS" and an NFS patch "nfs: skip commit in
> releasepage if we're freeing memory for fs-related reasons".

grumble.  This happened becase new stuff was added to -next right in
the middle of the merge window.  Please don't dothat.

