Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206Ab0JOJBJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 05:01:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60002 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754437Ab0JOJBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 05:01:07 -0400
Date: Fri, 15 Oct 2010 02:01:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Jan Engelhardt <jengelh@medozas.de>, Eric Paris <eparis@redhat.com>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        agruen@suse.de, davem@davemloft.net
Subject: Re: Process to push changes to include/linux/types.h
Message-Id: <20101015020134.e552d081.akpm@linux-foundation.org>
In-Reply-To: <878w1zc1ba.fsf@basil.nowhere.org>
References: <1287084892.3367.18.camel@dhcp231-212.rdu.redhat.com>
	<20101014125458.9e51ac58.akpm@linux-foundation.org>
	<alpine.LNX.2.01.1010142324400.31442@obet.zrqbmnf.qr>
	<20101014143723.ffea0d8c.akpm@linux-foundation.org>
	<alpine.LNX.2.01.1010142342400.31442@obet.zrqbmnf.qr>
	<878w1zc1ba.fsf@basil.nowhere.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Oct 2010 10:22:49 +0200 Andi Kleen <andi@firstfloor.org> wrote:

> Jan Engelhardt <jengelh@medozas.de> writes:
> 
> > I would be interested in knowing whether you - in whichever subsystems
> > you happen to be active - would even need aligned_u64. Right now,
> > the only users seem to be PPP and scsi_tgt besides Netfilter.
> 
> Using aligned_u64 is good practice to avoid problems with the 
> 32bit/64bit compat layer. I would recommend it to anyone 
> adding a new user space interface passing a 64bit value.
> 

What "problems" does it prevent when used for this?
