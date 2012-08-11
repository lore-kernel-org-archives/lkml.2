Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770Ab2HKTvb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2012 15:51:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36532 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab2HKTva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2012 15:51:30 -0400
Date: Sat, 11 Aug 2012 12:51:25 -0700
From: Tejun Heo <tj@kernel.org>
To: Jacob Shin <jacob.shin@amd.com>
Cc: X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH 0/5] Only create direct mappings for E820_RAM regions
Message-ID: <20120811195125.GD2874@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1344547389-4599-1-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344547389-4599-1-git-send-email-jacob.shin@amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2012 at 04:23:04PM -0500, Jacob Shin wrote:
> This is a revision of an earlier attempt, with suggestions and concernes
> from previous conversation (https://lkml.org/lkml/2011/12/16/486) taken
> into account.
> 
> The following patchset creates direct mappings only for E820_RAM regions
> between 0 ~ max_low_pfn and 4GB ~ max_pfn. And leaves non-E820_RAM
> unmapped.

Can you please explain why this is necessary here and in patch
descriptions?

Thanks.

-- 
tejun
