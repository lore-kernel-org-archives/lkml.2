Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513Ab2AYMfe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 07:35:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36376 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752665Ab2AYMfd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 07:35:33 -0500
Message-ID: <1327494921.17654.10.camel@cr0>
Subject: Re: linux-next: manual merge of the kmap_atomic tree with the
 ecryptfs tree
From: Cong Wang <amwang@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tyler Hicks <tyhicks@canonical.com>
Date: Wed, 25 Jan 2012 20:35:21 +0800
In-Reply-To: <20120125133201.faa14529e7f872d38a714fb5@canb.auug.org.au>
References: <20120125133201.faa14529e7f872d38a714fb5@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-01-25 at 13:32 +1100, Stephen Rothwell wrote:
> Hi Cong,
> 
> Today's linux-next merge of the kmap_atomic tree got a conflict in
> fs/ecryptfs/read_write.c between commit f28b7904d455 ("eCryptfs: Remove
> unused ecryptfs_read()") from the ecryptfs tree and commit 27de090e3326
> ("ecryptfs: remove the second argument of k[un]map_atomic()") from the
> kmap_atomic tree.
> 
> The former just removed the entire ecryptfs_read() function that was
> modified as part of the latter, so I did that.
> 

Hi, Stephen,

Sounds good to me! Thank you!


