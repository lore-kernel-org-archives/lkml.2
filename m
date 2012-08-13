Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656Ab2HMXCa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 19:02:30 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:58165 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739Ab2HMXC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 19:02:29 -0400
Date: Mon, 13 Aug 2012 16:02:24 -0700
From: Tejun Heo <tj@kernel.org>
To: Jacob Shin <jacob.shin@amd.com>
Cc: X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 5/5] x86: Move enabling of PSE and PGE out of
 init_memory_mapping
Message-ID: <20120813230224.GD25632@google.com>
References: <1344894424-4434-1-git-send-email-jacob.shin@amd.com>
 <1344894424-4434-6-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344894424-4434-6-git-send-email-jacob.shin@amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2012 at 04:47:04PM -0500, Jacob Shin wrote:
> Since we now call init_memory_mapping for each E820_RAM region in a
> loop, move cr4 writes out to setup_arch.

Wouldn't it be better if this happens *before* init_memory_mapping()
is called multiple times?

Thanks.

-- 
tejun
