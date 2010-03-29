Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703Ab0C2Ul2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 16:41:28 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:43685 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381Ab0C2Ul0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 16:41:26 -0400
Date: Mon, 29 Mar 2010 14:41:24 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Stefan Bader <stefan.bader@canonical.com>
Cc: mingo@elte.hu, hpa@zytor.com, linux-kernel@vger.kernel.org,
       James.Bottomley@suse.de
Subject: Re: [PATCH] dma-mapping: Remove WARN_ON in dma_free_coherent
Message-ID: <20100329204123.GA32165@parisc-linux.org>
References: <1269886161-2616-1-git-send-email-stefan.bader@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269886161-2616-1-git-send-email-stefan.bader@canonical.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 29, 2010 at 08:09:21PM +0200, Stefan Bader wrote:
> But it seems modifying that driver would be a bigger effort and maybe
> not really worthwile as it is a rather old driver. On the other side
> I was told [1] that this WARN_ON applies only to ARM which could sleep
> in the free path and it is just bogus for X86. As the code is in
> arch/x86 it would never be used for anything else than X86 and if
> its truely bogus on X86, couldn't it get removed?

My suggestion was that you remove it from the Ubuntu kernel, not submit
it upstream.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
