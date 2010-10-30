Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762219Ab0J3Bbl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 21:31:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50836 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752106Ab0J3Bbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 21:31:38 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTikEpV7GWG9fd3=zfrhOZtbPvxJWfXAO30iN8aae@mail.gmail.com>
References: <20100212091609.GB1025@kernel.dk> <alpine.LFD.2.00.1002120722270.7792@localhost.localdomain>
 <alpine.LSU.2.01.1002131356250.20838@obet.zrqbmnf.qr> <20100215144938.GD3434@quack.suse.cz>
 <alpine.LSU.2.01.1002151629380.27775@obet.zrqbmnf.qr> <alpine.LSU.2.01.1006271842220.1495@obet.zrqbmnf.qr>
 <alpine.LNX.2.01.1010250115360.16022@obet.zrqbmnf.qr> <AANLkTikBmewDmBJWHzdTerJE2W4GqRYMxLCdAJyz5JDB@mail.gmail.com>
 <AANLkTikEpV7GWG9fd3=zfrhOZtbPvxJWfXAO30iN8aae@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 29 Oct 2010 18:30:40 -0700
Message-ID: <AANLkTim__sKhnJoHFKvDHEZ0=OXjEtDqDsPx7CbixjzW@mail.gmail.com>
Subject: Re: Sync writeback still broken
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, stable@kernel.org,
        Greg KH <gregkh@suse.de>, Jens Axboe <jaxboe@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 29, 2010 at 6:16 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I dunno. Who even uses WB_SYNC_ALL? It's just "sync()" itself, isn't
> it? And "umount()", I guess. I didn't actually look at the code.

Hmm. The test-case Jan provided doesn't seem to do sync() or anything,
so either this is different from his original email issues, or there's
some external "sync()" going on unmentioned. Or something else
entirely?

                Linus
