Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933387Ab0HJWTI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 18:19:08 -0400
Received: from daytona.panasas.com ([67.152.220.89]:19662 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932759Ab0HJWTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 18:19:05 -0400
Message-ID: <4C61D055.4090909@panasas.com>
Date: Tue, 10 Aug 2010 18:19:01 -0400
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paul Bolle <pebolle@tiscali.nl>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: linux-next: manual merge of the trivial tree with the vfs tree
References: <20100810121900.cbceb878.sfr@canb.auug.org.au>
In-Reply-To: <20100810121900.cbceb878.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Aug 2010 22:19:03.0495 (UTC) FILETIME=[0A2D2D70:01CB38DA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2010 10:19 PM, Stephen Rothwell wrote:
> Hi Jiri,
> 
> Today's linux-next merge of the trivial tree got a conflict in
> fs/exofs/inode.c between commit 21883a7d05d4c1e97943fa1a587aa2c2a3b09e8c
> ("exofs: New truncate sequence") from the vfs tree and commit
> 426d31071ac476ea62c62656b242930c17b58c00 ("fix printk typo 'faild'") from
> the trivial tree.
> 
> Just context changes.  I fixed it up (see below) and can carry it for a
> while.

The "exofs: New truncate sequence" is now in the Kernel. So perhaps
fix printk typo 'faild'" could be rebased.

Or you can send the patch to me and I'll push it. Which ever you
prefer

Thanks
Boaz

