Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab0JOKNi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 06:13:38 -0400
Received: from borg.medozas.de ([188.40.89.202]:32926 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751677Ab0JOKNh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 06:13:37 -0400
Date: Fri, 15 Oct 2010 12:13:33 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Andi Kleen <andi@firstfloor.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Eric Paris <eparis@redhat.com>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        agruen@suse.de, davem@davemloft.net
Subject: Re: Process to push changes to include/linux/types.h
In-Reply-To: <878w1zc1ba.fsf@basil.nowhere.org>
Message-ID: <alpine.LNX.2.01.1010151212350.788@obet.zrqbmnf.qr>
References: <1287084892.3367.18.camel@dhcp231-212.rdu.redhat.com> <20101014125458.9e51ac58.akpm@linux-foundation.org> <alpine.LNX.2.01.1010142324400.31442@obet.zrqbmnf.qr> <20101014143723.ffea0d8c.akpm@linux-foundation.org> <alpine.LNX.2.01.1010142342400.31442@obet.zrqbmnf.qr>
 <878w1zc1ba.fsf@basil.nowhere.org>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 2010-10-15 10:22, Andi Kleen wrote:
>Jan Engelhardt writes:
>
>> I would be interested in knowing whether you - in whichever subsystems
>> you happen to be active - would even need aligned_u64. Right now,
>> the only users seem to be PPP and scsi_tgt besides Netfilter.
>
>Using aligned_u64 is good practice to avoid problems with the 
>32bit/64bit compat layer. I would recommend it to anyone 
>adding a new user space interface passing a 64bit value.

Well, new interfaces in networking are using netlink, which has its own 
unlucky ideas of alignment.
