Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378Ab2HMXUr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 19:20:47 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:60306 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754334Ab2HMXUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 19:20:45 -0400
Date: Mon, 13 Aug 2012 16:20:40 -0700
From: Tejun Heo <tj@kernel.org>
To: Borislav Petkov <bp@alien8.de>, Jacob Shin <jacob.shin@amd.com>,
        X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH 5/5] x86: Move enabling of PSE and PGE out of
 init_memory_mapping
Message-ID: <20120813232040.GE25632@google.com>
References: <1344547389-4599-1-git-send-email-jacob.shin@amd.com>
 <1344547389-4599-6-git-send-email-jacob.shin@amd.com>
 <20120811200133.GG2874@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120813073440.GC16654@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120813073440.GC16654@liondog.tnic>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Aug 13, 2012 at 09:34:40AM +0200, Borislav Petkov wrote:
> On Sat, Aug 11, 2012 at 01:01:33PM -0700, Tejun Heo wrote:
> > Shouldn't this happen before init_memory_mapping() is called multiple
> > times?
> 
> It does.
> 
> Those CR4 flags are set before the loop which calls init_memory_mapping().

I meant the patch should come before the patch making multiple calls
to init_memory_mapping().

> > Also, there seem to be other stuff which need to be moved out.
> 
> Which are those pls?

Rebuilding pgtable on each invocation?

Thanks.

-- 
tejun
