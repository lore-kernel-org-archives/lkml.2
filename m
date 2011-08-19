Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109Ab1HSHG6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 03:06:58 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:24089 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755Ab1HSHG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 03:06:57 -0400
Date: Fri, 19 Aug 2011 09:07:25 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: WANG Cong <amwang@redhat.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Andy Grover <agrover@redhat.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Christoph Hellwig <hch@lst.de>, Kiran Patil <kiran.patil@intel.com>,
        Yi Zou <yi.zou@intel.com>, Dan Carpenter <error27@gmail.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: Re: [Patch] target: remove needless include of version.h
In-Reply-To: <1313736815-27234-1-git-send-email-amwang@redhat.com>
Message-ID: <alpine.LNX.2.00.1108190906280.31857@swampdragon.chaosbits.net>
References: <1313736815-27234-1-git-send-email-amwang@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Aug 2011, WANG Cong wrote:

> They don't version.h to be compiled. Compiling tested.
> 

Looks more or less identical to the patch I submitted on Aug 1 (and 
earlier) : https://lkml.org/lkml/2011/8/1/309


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

