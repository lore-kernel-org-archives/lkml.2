Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751109Ab2HLPOV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 11:14:21 -0400
Received: from natasha.panasas.com ([67.152.220.90]:46017 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733Ab2HLPOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 11:14:19 -0400
Message-ID: <5027C836.4070904@panasas.com>
Date: Sun, 12 Aug 2012 18:13:58 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111113 Thunderbird/8.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: Re: linux-next: manual merge of the osd tree with the nfs tree
References: <20120809100328.b8d6af3b95e1537ffcb7b053@canb.auug.org.au>
In-Reply-To: <20120809100328.b8d6af3b95e1537ffcb7b053@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2012 03:03 AM, Stephen Rothwell wrote:

> Hi Boaz,
> 
> Today's linux-next merge of the osd tree got a conflict in
> fs/nfs/nfs4proc.c between commit 47fbf7976e0b ("NFSv4.1: Remove a bogus
> BUG_ON() in nfs4_layoutreturn_done") from the nfs tree and commit
> d8e8b68405db ("pnfs: Don't BUG on info received from Server") from the
> osd tree.
> 
> I just used the nfs tree version.


Sorry, was on vacation will fix right now. Your fix was correct

Thanks
Boaz

