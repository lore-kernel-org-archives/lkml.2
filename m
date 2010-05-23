Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988Ab0EWCmg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 22:42:36 -0400
Received: from lon1-post-2.mail.demon.net ([195.173.77.149]:40780 "EHLO
	lon1-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755678Ab0EWCme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 22:42:34 -0400
Message-ID: <4BF8957A.9090506@lougher.demon.co.uk>
Date: Sun, 23 May 2010 03:39:54 +0100
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: linux-next: build warning after merge of the squashfs tree
References: <20100522163042.13478ac4.sfr@canb.auug.org.au>
In-Reply-To: <20100522163042.13478ac4.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi Phillip,
> 
> After merging the squashfs tree, today's linux-next build (x86_64
> allmodconfig) produced this warning:
> 
> fs/squashfs/super.c: In function 'squashfs_fill_super':
> fs/squashfs/super.c:265: warning: assignment from incompatible pointer type
> 
> Introduced by commit 67f66cc6c728de183d9d43c243cb163c1ebd8e04 ("squashfs:
> add new extended inode types") from the squashfs tree interacting with
> commit bb4354538eb7b92f32cfedbad68c7be266c0b467 ("fs: xattr_handler table
> should be const") from Linus' tree.

Fixed.  Thanks.

Phillip

