Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760186Ab2CaPNf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 11:13:35 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:47636 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760124Ab2CaPN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 11:13:29 -0400
X-Sasl-enc: rpVZQMZaAxlDanBtWsO/WvaHTvh5BFsVdzSnviVrcPa5 1333206807
Date: Sat, 31 Mar 2012 08:13:27 -0700
From: Greg KH <greg@kroah.com>
To: Indan Zupancic <indan@nul.nu>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: bpf_jit: fix BPF_S_ALU_AND_K compilation
Message-ID: <20120331151327.GA25059@kroah.com>
References: <40f4b91c5200771f223966f368095c63.squirrel@webmail.greenhost.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40f4b91c5200771f223966f368095c63.squirrel@webmail.greenhost.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 31, 2012 at 08:52:09PM +1100, Indan Zupancic wrote:
> Hello,
> 
> Finally, after much searching I found one little bug.
> 
> [PATCH] net: bpf_jit: fix BPF_S_ALU_AND_K compilation
> 
> Small typo resulted in bad code generation for certain
> values of K for the BPF_S_ALU_AND_K instruction.
> 
> Signed-off-by: Indan Zupancic <indan@nul.nu>
> ---
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
