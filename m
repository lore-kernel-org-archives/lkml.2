Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205Ab1GAURK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 16:17:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:55283 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541Ab1GAURI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 16:17:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,460,1304319600"; 
   d="scan'208";a="20678014"
From: Andi Kleen <andi@firstfloor.org>
To: ling.ma@intel.com
Cc: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 1/2 ] [x86] Modify comments and clean up code.
References: <1309300570-789-1-git-send-email-ling.ma@intel.com>
Date: Fri, 01 Jul 2011 13:15:46 -0700
In-Reply-To: <1309300570-789-1-git-send-email-ling.ma@intel.com> (ling ma's
	message of "Wed, 29 Jun 2011 06:36:10 +0800")
Message-ID: <m2y60hlpu5.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ling.ma@intel.com writes:

> From: Ma Ling <ling.ma@intel.com>
>
> Modern CPU use fast-string instruction to accelerate copy performance,
> by combining data into 128bit, so we modify comments and code style.

The description has nothing to do with the patch.

As far as I can tell the patch just renames one symbol
and changes all white space. Not fully sure what the point of it 
is. 

But normally white space change patches are not supposed to have
any other changes because the other changes embedded in them
are impossible to review.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
