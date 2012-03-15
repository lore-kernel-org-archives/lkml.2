Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965383Ab2COBFh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 21:05:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:12260 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965341Ab2COBFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 21:05:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="117795178"
Date: Wed, 14 Mar 2012 18:05:36 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Sasha Levin <levinsasha928@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, davej@redhat.com
Subject: Re: [PATCH] vfs namespace: Don't assume mount namespace has valid
 root
Message-ID: <20120315010536.GC8817@tassilo.jf.intel.com>
References: <1331758710-16400-1-git-send-email-levinsasha928@gmail.com>
 <20120314201048.GI23916@ZenIV.linux.org.uk>
 <20120314205809.GJ23916@ZenIV.linux.org.uk>
 <CA+1xoqcvXsx1vpAB7Jg-dWGVaadbF4sC3Cr2s5itHfdiPFQerA@mail.gmail.com>
 <20120314213746.GK23916@ZenIV.linux.org.uk>
 <CA+1xoqcP-1rU79ZOD2t+cn8tr77Nxmhv0_MjuLcvp67Zb7FFKQ@mail.gmail.com>
 <20120314221908.GM23916@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120314221908.GM23916@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>          * Second pass: switch the tsk->fs->* elements and mark new vfsmounts
> @@ -2416,9 +2416,9 @@ bool is_path_reachable(struct mount *mnt, struct dentry *dentry,
> 
> IOW, Andi has hit delete one too many times...

Oops. Sorry about that. Thanks for catching it.

The obvious patch looks good to me of course.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
