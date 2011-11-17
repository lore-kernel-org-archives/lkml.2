Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882Ab1KQR57 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 12:57:59 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:40277 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751066Ab1KQR56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 12:57:58 -0500
Date: Thu, 17 Nov 2011 17:57:37 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Laura Abbott <lauraa@codeaurora.org>
Cc: "mingo@elte.hu" <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [RFC PATCH] kmemleak: Add support for memory hotplug
Message-ID: <20111117175737.GA23875@arm.com>
References: <1321400949-1852-1-git-send-email-lauraa@codeaurora.org>
 <1321400949-1852-2-git-send-email-lauraa@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321400949-1852-2-git-send-email-lauraa@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 15, 2011 at 11:49:09PM +0000, Laura Abbott wrote:
> Ensure that memory hotplug can co-exist with kmemleak
> by taking the hotplug lock before scanning the memory
> banks.
> 
> Signed-off-by: Laura Abbott <lauraa@codeaurora.org>

Thanks, the patch looks fine to me. I'll add it to my kmemleak branch
for the next merging window.

-- 
Catalin
