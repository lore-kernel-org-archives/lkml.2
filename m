Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157Ab2HMWJT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 18:09:19 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38550 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754880Ab2HMWJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 18:09:16 -0400
Date: Mon, 13 Aug 2012 15:09:11 -0700
From: Tejun Heo <tj@kernel.org>
To: Jacob Shin <jacob.shin@amd.com>
Cc: X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 3/5] x86: Keep track of direct mapped pfn ranges
Message-ID: <20120813220911.GC25632@google.com>
References: <1344894424-4434-1-git-send-email-jacob.shin@amd.com>
 <1344894424-4434-4-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344894424-4434-4-git-send-email-jacob.shin@amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2012 at 04:47:02PM -0500, Jacob Shin wrote:
> Update later calls to init_memory_mapping to keep track of direct mapped
> pfn ranges so that at any point in time we can accurately represent what
> memory ranges are direct mapped or not.

Maybe we want to roll add_pfn_range_mapped() call into
init_memory_mapping()?

Thanks.

-- 
tejun
