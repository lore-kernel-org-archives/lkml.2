Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484Ab2HKUBj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2012 16:01:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44605 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab2HKUBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2012 16:01:38 -0400
Date: Sat, 11 Aug 2012 13:01:33 -0700
From: Tejun Heo <tj@kernel.org>
To: Jacob Shin <jacob.shin@amd.com>
Cc: X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH 5/5] x86: Move enabling of PSE and PGE out of
 init_memory_mapping
Message-ID: <20120811200133.GG2874@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1344547389-4599-1-git-send-email-jacob.shin@amd.com>
 <1344547389-4599-6-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344547389-4599-6-git-send-email-jacob.shin@amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Aug 09, 2012 at 04:23:09PM -0500, Jacob Shin wrote:
> Since we now call init_memory_mapping for each E820_RAM region in a
> loop, move cr4 writes out to setup_arch.

Shouldn't this happen before init_memory_mapping() is called multiple
times?  Also, there seem to be other stuff which need to be moved out.

Thanks.

-- 
tejun
