Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445Ab1EXXOd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 19:14:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59831 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754804Ab1EXXOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 19:14:32 -0400
Message-ID: <4DDC3BC3.4010804@zytor.com>
Date: Tue, 24 May 2011 16:14:11 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Dan Rosenberg <drosenberg@vsecurity.com>
CC: Tony Luck <tony.luck@gmail.com>, linux-kernel@vger.kernel.org,
        davej@redhat.com, kees.cook@canonical.com, davem@davemloft.net,
        eranian@google.com, torvalds@linux-foundation.org, adobriyan@gmail.com,
        penberg@kernel.org, Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        Ingo Molnar <mingo@elte.hu>, pageexec@freemail.hu
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
References: <1306269105.21443.20.camel@dan> <4DDC31DF.5010303@zytor.com>
In-Reply-To: <4DDC31DF.5010303@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2011 03:31 PM, H. Peter Anvin wrote:
> 
> Arguably this is really something that would be *much* better done in
> the bootloader, but given that the dominant boot loader for Linux is
> Grub, I don't expect that anything will ever happen until the cows come
> home :(
> 

This pretty much means we need an opt-out for this.  I think we need
this both in the form of a boot protocol flag bit (for the case where
the boot loader knows what it's doing, and what the kernel to stay put;
perhaps it has already randomized) and a kernel command-line option
(which can be parsed early and set the above flag.)

	-hpa
