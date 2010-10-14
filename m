Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932215Ab0JNWCi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 18:02:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40190 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755578Ab0JNWCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 18:02:37 -0400
Date: Thu, 14 Oct 2010 15:01:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, agruen@suse.de, davem@davemloft.net,
        andi@firstfloor.org
Subject: Re: Process to push changes to include/linux/types.h
Message-Id: <20101014150144.3d895940.akpm@linux-foundation.org>
In-Reply-To: <alpine.LNX.2.01.1010142342400.31442@obet.zrqbmnf.qr>
References: <1287084892.3367.18.camel@dhcp231-212.rdu.redhat.com>
	<20101014125458.9e51ac58.akpm@linux-foundation.org>
	<alpine.LNX.2.01.1010142324400.31442@obet.zrqbmnf.qr>
	<20101014143723.ffea0d8c.akpm@linux-foundation.org>
	<alpine.LNX.2.01.1010142342400.31442@obet.zrqbmnf.qr>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Oct 2010 23:50:34 +0200 (CEST)
Jan Engelhardt <jengelh@medozas.de> wrote:

> 
> On Thursday 2010-10-14 23:37, Andrew Morton wrote:
> >> >The usual approach here is someone sends it to me and I send it to
> >> >Linus ;)
> >> 
> >> We tinkered on types.h before, with the change originating in the Netfilter
> >> subtree, and nobody, not even Dave, complained.
> >
> >It doesn't matter much at all what tree a change goes through.  What
> >matters more is that the appropriate people know about and see the
> >change.
> >
> >For example, I never even knew that aligned_u64 and friends existed (it
> >got secretly merged via the netfilter tree, apparently).
> 
> I would be interested in knowing whether you - in whichever subsystems
> you happen to be active - would even need aligned_u64. Right now,
> the only users seem to be PPP and scsi_tgt besides Netfilter.
> 

Stranger things have happened.

include/linux/net_dropmon.h:net_dm_config_entry can perhaps be
converted btw.

