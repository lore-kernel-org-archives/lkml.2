Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933756Ab1CXP7v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 11:59:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:21405 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933534Ab1CXP7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 11:59:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,237,1299484800"; 
   d="scan'208";a="724686048"
From: Andi Kleen <andi@firstfloor.org>
To: Len Brown <lenb@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, Len Brown <len.brown@intel.com>
Subject: Re: [PATCH 4/5] x86 idle floppy: delete disable_hlt()/enable_hlt()
References: <1300950508-22746-1-git-send-email-lenb@kernel.org>
	<fb07f62522099f5d3f2b7aa6014329d716081b62.1300950095.git.len.brown@intel.com>
Date: Thu, 24 Mar 2011 08:58:25 -0700
In-Reply-To: <fb07f62522099f5d3f2b7aa6014329d716081b62.1300950095.git.len.brown@intel.com>
	(Len Brown's message of "Thu, 24 Mar 2011 03:08:27 -0400")
Message-ID: <m239mcv7by.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Len Brown <lenb@kernel.org> writes:
>
> floppy.c said:
>
> "disable hlt during certain critical i/o operations"
>
> x86/kernel/process.c said:
>
> "This halt magic was a workaround for ancient floppy DMA
>  wreckage. It should be safe to remove."

AFAIK it was used on some 386/486s. I suspect it's safe to remove now.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only
