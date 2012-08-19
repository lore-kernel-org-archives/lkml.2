Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983Ab2HSVTF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 17:19:05 -0400
Received: from mga01.intel.com ([192.55.52.88]:45880 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751127Ab2HSVTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 17:19:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,794,1336374000"; 
   d="scan'208";a="205763621"
From: Andi Kleen <andi@firstfloor.org>
To: Jean-Christophe DUBOIS <jcd@tribudubois.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Question on SLAB allocator.
References: <503141B5.7070705@tribudubois.net>
Date: Sun, 19 Aug 2012 14:18:58 -0700
In-Reply-To: <503141B5.7070705@tribudubois.net> (Jean-Christophe DUBOIS's
	message of "Sun, 19 Aug 2012 21:42:45 +0200")
Message-ID: <m2obm68trx.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean-Christophe DUBOIS <jcd@tribudubois.net> writes:

Slab supports constructors.  Reusing state from freeing at next
allocation of the same type to optimize use of the CPU caches. The inode
cache among others use this.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
