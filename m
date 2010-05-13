Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758054Ab0EMJEx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 05:04:53 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57545 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757876Ab0EMJEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 05:04:50 -0400
To: Huang Ying <ying.huang@intel.com>
Cc: lenb@kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH -v2 2/2] ACPI, APEI, EINJ injection parameters support
From: Andi Kleen <andi@halobates.de>
References: <1273716563-23573-1-git-send-email-ying.huang@intel.com>
	<1273716563-23573-3-git-send-email-ying.huang@intel.com>
Date: Thu, 13 May 2010 11:04:45 +0200
In-Reply-To: <1273716563-23573-3-git-send-email-ying.huang@intel.com> (Huang Ying's message of "Thu\, 13 May 2010 10\:09\:23 +0800")
Message-ID: <877hn8uq8i.fsf@basil.nowhere.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang Ying <ying.huang@intel.com> writes:

> Some hardware error injection needs parameters, for example, it is
> useful to specify memory address and memory address mask for memory
> errors.
>
> Some BIOSes allow parameters to be specified via an unpublished
> extension. This patch adds support to it. The parameters will be
> ignored on machines without necessary BIOS support.

Reviewed-by: Andi Kleen <ak@linux.intel.com>

Looks good. Len please add to the existing APEI queue.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
