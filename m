Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563Ab1HSXdd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 19:33:33 -0400
Received: from mga03.intel.com ([143.182.124.21]:58914 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753946Ab1HSXdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 19:33:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,253,1312182000"; 
   d="scan'208";a="9114227"
From: Andi Kleen <andi@firstfloor.org>
To: "Peter Hanzel" <hanzelpeter@gmail.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.0.3 GCC 4.6.1 kernel BUGs
References: <C3F04976DA604F6CA3949E98B2A7B832@avitech.sk>
Date: Fri, 19 Aug 2011 16:33:31 -0700
In-Reply-To: <C3F04976DA604F6CA3949E98B2A7B832@avitech.sk> (Peter Hanzel's
	message of "Fri, 19 Aug 2011 14:25:20 +0200")
Message-ID: <m239gxht84.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Peter Hanzel" <hanzelpeter@gmail.com> writes:
>
> See trace 3 on the end.

Something is very broken in your kernel. Changing the user programs
won't fix it.
>
> This all looks to me like GCC 4.6.1 is broken somehow.

How did you determine this?  Did you test with another
compiler and it worked?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
