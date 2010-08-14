Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757138Ab0HNW20 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 18:28:26 -0400
Received: from legolas.restena.lu ([158.64.1.34]:45310 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756746Ab0HNW2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 18:28:25 -0400
Date: Sun, 15 Aug 2010 00:27:26 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: sedat.dilek@googlemail.com
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.36-git: BUG in highmem_32.c:45 causing scheduling while
 atomic
Message-ID: <20100815002726.698a1364@neptune.home>
In-Reply-To: <AANLkTikMnW2PfMAQdJKtDGPYeqkev7aJiDMUp6CBznm4@mail.gmail.com>
References: <AANLkTikMnW2PfMAQdJKtDGPYeqkev7aJiDMUp6CBznm4@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 August 2010 Sedat Dilek <sedat.dilek@googlemail.com> wrote:
> Looks like another side-effect of BR #16588 to me?
> 
> Can you try the revert-patches attached to [1], re-compile and give feedback?
> 
> - Sedat -
> 
> [1] https://bugzilla.kernel.org/show_bug.cgi?id=16588

Linus's fixup patch (from "Linux 2.6.35.2" thread, committed as
"mm: fix page table unmap for stack guard page properly",
11ac552477e32835cb6970bf0a70c210807f5673) seems to fix it as well.

Thanks,
Bruno
