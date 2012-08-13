Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719Ab2HMHeq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 03:34:46 -0400
Received: from mail.skyhub.de ([78.46.96.112]:41155 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751702Ab2HMHeo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 03:34:44 -0400
Date: Mon, 13 Aug 2012 09:34:40 +0200
From: Borislav Petkov <bp@alien8.de>
To: Tejun Heo <tj@kernel.org>
Cc: Jacob Shin <jacob.shin@amd.com>, X86-ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH 5/5] x86: Move enabling of PSE and PGE out of
 init_memory_mapping
Message-ID: <20120813073440.GC16654@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>, Tejun Heo <tj@kernel.org>,
	Jacob Shin <jacob.shin@amd.com>, X86-ML <x86@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
	Andreas Herrmann <andreas.herrmann3@amd.com>
References: <1344547389-4599-1-git-send-email-jacob.shin@amd.com>
 <1344547389-4599-6-git-send-email-jacob.shin@amd.com>
 <20120811200133.GG2874@dhcp-172-17-108-109.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120811200133.GG2874@dhcp-172-17-108-109.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On Sat, Aug 11, 2012 at 01:01:33PM -0700, Tejun Heo wrote:
> Shouldn't this happen before init_memory_mapping() is called multiple
> times?

It does.

Those CR4 flags are set before the loop which calls init_memory_mapping().

> Also, there seem to be other stuff which need to be moved out.

Which are those pls?

Thanks.

-- 
Regards/Gruss,
    Boris.
