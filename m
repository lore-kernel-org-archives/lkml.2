Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759243Ab1ENUeS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 16:34:18 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:65304 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758988Ab1ENUeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 16:34:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 1/2] ARM: ELF: Define new core note type for VFP registers
Date: Fri, 13 May 2011 21:24:10 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Dave Martin <dave.martin@linaro.org>,
        Ulrich Weigand <ulrich.weigand@linaro.org>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        patches@linaro.org, Will Deacon <Will.Deacon@arm.com>,
        lkml <linux-kernel@vger.kernel.org>
References: <1302688597-2969-1-git-send-email-dave.martin@linaro.org> <20110513065902.GA2867@localhost> <alpine.LFD.2.00.1105130926180.2762@xanadu.home>
In-Reply-To: <alpine.LFD.2.00.1105130926180.2762@xanadu.home>
MIME-Version: 1.0
Message-Id: <201105132124.11176.arnd@arndb.de>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:diU39ScX2hEezm3VE/sMUJ6lddL7nZUt/FD6rLd2dKV
 H0BwPq23JZAbL0yFwaLhzVywCWXXuLpMNEpzJ2WZei9jbER+eS
 +bE5X5SnyJEsaR14a45MQq0n4nROoDH6iiFrpitgZauaMnzEAf
 VscGx33gOqFTJ90dMImN0/sTtDwvKagwbINjb2cCdNElSsD6zG
 dPUxF2ePM1EV98fjrPwzQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 May 2011, Nicolas Pitre wrote:
> On Fri, 13 May 2011, Dave Martin wrote:
> 
> > On Thu, May 12, 2011 at 10:14:00AM +0100, Russell King - ARM Linux wrote:
> > > On Tue, May 03, 2011 at 10:36:59AM +0100, Dave Martin wrote:
> > > > On Thu, Apr 28, 2011 at 07:49:25PM +0100, Russell King - ARM Linux wrote:
> > > > > On Wed, Apr 13, 2011 at 10:56:36AM +0100, Dave Martin wrote:
> > > > > > The VFP registers are not currently included in coredumps,
> > > > > > and there's no existing note type where they can sensibly be
> > > > > > included, so this patch defines a dedicated note type for them.
> > > > > 
> > > > > This probably wants to be copied to LKML (added).
> > > > 
> > > > Good point-- thanks.
> > > 
> > > What news on this?
> > 
> > None whatsoever.  Do you think I need to push harder for feedback?
> 
> I think that the patch should just be merged.  If someone had a problem 
> with this, we would have heard about it by now.
> 

Agreed. Uli and other toolchain people are waiting for this to get merged,
so we can put the ABI into gdb releases. It's definitely useful, and I couldn't
find anything wrong with it (but don't have much experience with ptrace).

	Arnd

