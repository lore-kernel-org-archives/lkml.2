Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304Ab0DSIsg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 04:48:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:52890 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753168Ab0DSIsf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 04:48:35 -0400
Message-ID: <4BCC1998.2090604@kernel.org>
Date: Mon, 19 Apr 2010 17:51:36 +0900
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
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 19 Apr 2010 08:48:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2010 01:37 AM, Jan Kiszka wrote:
> We now have to to include linux/slab.h explicitly for kmalloc & friends.
> Files that build against host headers already get their prototypes via
> um_malloc.h, linux/slab.h may even be unavailable.
> 
> Signed-off-by: Jan Kiszka <jan.kiszka@web.de>

applied to percpu#for-linus/next.  Will push to Linus in a few days.

Thanks.

-- 
tejun
