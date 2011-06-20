Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623Ab1FTTtY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 15:49:24 -0400
Received: from mga09.intel.com ([134.134.136.24]:37492 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751731Ab1FTTtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 15:49:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,396,1304319600"; 
   d="scan'208";a="16058340"
From: Andi Kleen <andi@firstfloor.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC] get_write_access()/deny_write_access() without inode->i_lock
References: <20110619235147.GQ11521@ZenIV.linux.org.uk>
Date: Mon, 20 Jun 2011 12:47:54 -0700
In-Reply-To: <20110619235147.GQ11521@ZenIV.linux.org.uk> (Al Viro's message of
	"Mon, 20 Jun 2011 00:51:47 +0100")
Message-ID: <m21uyoffo5.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> writes:

> 	I'm seriously tempted to throw away i_lock uses in
> {get,deny}_write_access(), as in the patch below.  The question is, how

Are there any known workload where the spinlock contends badly here?
Or what's the motivation for it?

Thanks,

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
