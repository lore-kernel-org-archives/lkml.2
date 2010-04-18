Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665Ab0DRVVL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Apr 2010 17:21:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:35039 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752928Ab0DRVVJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Apr 2010 17:21:09 -0400
Message-ID: <4BCB788E.2040501@kernel.org>
Date: Mon, 19 Apr 2010 06:24:30 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@web.de>
CC: Jeff Dike <jdike@addtoit.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       user-mode-linux-devel@lists.sourceforge.net,
       Tiger Yang <tiger.yang@oracle.com>
Subject: Re: [PATCH] uml: Fix build breakage after slab.h changes
References: <4BCB353A.3040806@web.de>
In-Reply-To: <4BCB353A.3040806@web.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 18 Apr 2010 21:20:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 04/19/2010 01:37 AM, Jan Kiszka wrote:
> We now have to to include linux/slab.h explicitly for kmalloc & friends.
> Files that build against host headers already get their prototypes via
> um_malloc.h, linux/slab.h may even be unavailable.

Hmmm... my test um build was okay but I don't know much about details
of um builds.  I suppose this patch will go through um tree?

Thanks.

-- 
tejun
