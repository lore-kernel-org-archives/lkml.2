Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756442Ab0JVL7a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 07:59:30 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35786 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756248Ab0JVL70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 07:59:26 -0400
Date: Fri, 22 Oct 2010 13:59:25 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/9] ACPI, APEI patches for 2.6.37
Message-ID: <20101022115924.GE10456@basil.fritz.box>
References: <1287538620-7442-1-git-send-email-ying.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287538620-7442-1-git-send-email-ying.huang@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 20, 2010 at 09:36:51AM +0800, Huang Ying wrote:
> [PATCH 1/9] ACPI, APEI, Add ERST record ID cache
> [PATCH 2/9] Add lock-less version of bitmap_set/clear
> [PATCH 3/9] lock-less NULL terminated single list implementation
> [PATCH 4/9] lock-less general memory allocator
> [PATCH 5/9] Hardware error device core
> [PATCH 6/9] Hardware error record persistent support
> [PATCH 7/9] ACPI, APEI, Use ERST for hardware error persisting before panic
> [PATCH 8/9] ACPI, APEI, Report GHES error record with hardware error device core
> [PATCH 9/9] ACPI, APEI, Generic Hardware Error Source POLL/IRQ/NMI notification type support

I reviewed the whole series and it all looks good to me.

Some things could be cleaned up,  but it's all very minor.

Reviewed-by: Andi Kleen <ak@linux.intel.com>


-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
