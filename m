Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694Ab2JUVWu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 17:22:50 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54679 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754257Ab2JUVWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 17:22:49 -0400
Date: Sun, 21 Oct 2012 14:22:43 -0700
From: Tom Rini <trini@ti.com>
To: Jacob Shin <jacob.shin@amd.com>
Cc: X86-ML <x86@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] x86: find_early_table_space based on memory ranges
 that are being mapped
Message-ID: <20121021212243.GA2867@bill-the-cat>
References: <1345852516-3125-1-git-send-email-jacob.shin@amd.com>
 <1345852516-3125-3-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345852516-3125-3-git-send-email-jacob.shin@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2012 at 06:55:13PM -0500, Jacob Shin wrote:

> Current logic finds enough space for direct mapping page tables from 0
> to end. Instead, we only need to find enough space to cover mr[0].start
> to mr[nr_range].end -- the range that is actually being mapped by
> init_memory_mapping()
> 
> This patch also reportedly fixes suspend/resume issue reported in:
> 
> https://lkml.org/lkml/2012/8/11/83
> 
> Signed-off-by: Jacob Shin <jacob.shin@amd.com>

This fixes a bug I see that was introduced in 1bbbbe7

Tested-by: Tom Rini <trini@ti.com>

-- 
Tom
