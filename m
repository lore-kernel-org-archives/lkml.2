Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755724Ab0CXL2w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 07:28:52 -0400
Received: from tac.ki.iif.hu ([193.6.222.43]:43104 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755354Ab0CXL2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 07:28:51 -0400
From: Ferenc Wagner <wferi@niif.hu>
To: Peter Korsgaard <jacmet@sunsite.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org
Subject: Re: RFC: direct MTD support for SquashFS
References: <87vdcwv139.fsf@tac.ki.iif.hu>
	<87ljdsibqe.fsf@macbook.be.48ers.dk> <87r5nhziss.fsf@tac.ki.iif.hu>
	<bffbecbb1003181440kc78f4dbvd25d4e2ea17b52e5@mail.gmail.com>
	<8739zqpxxw.fsf@tac.ki.iif.hu> <4BA9A1BB.4000105@lougher.demon.co.uk>
	<87y6hii5wq.fsf@macbook.be.48ers.dk>
Date: Wed, 24 Mar 2010 12:28:43 +0100
In-Reply-To: <87y6hii5wq.fsf@macbook.be.48ers.dk> (Peter Korsgaard's message
	of "Wed, 24 Mar 2010 07:35:01 +0100")
Message-ID: <871vfam00k.fsf@tac.ki.iif.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Korsgaard <jacmet@sunsite.dk> writes:

>>>>>> "Phillip" == Phillip Lougher <phillip@lougher.demon.co.uk> writes:
>
>  Phillip> BTW as a comparison, I have added MTD support to Squashfs
>  Phillip> twice in the past, *with* bad block support.  The latest has a
>  Phillip> diff patch of ~500 lines, with far less complexity and code
>  Phillip> changes necessary.
>
> Again, what kind of size reduction can we expect from getting rid of
> the block layer?

My size-optimized OpenWRT vmlinux shrank ~170 kB after disabling
CONFIG_BLOCK.  Similarly for the memory consumption.
-- 
Regards,
Feri.
