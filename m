Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935473Ab1IOXd4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 19:33:56 -0400
Received: from www.linutronix.de ([62.245.132.108]:47567 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935437Ab1IOXdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 19:33:55 -0400
Date: Fri, 16 Sep 2011 01:33:54 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: Tree sweep to fix up initconst
In-Reply-To: <1316117394-21666-1-git-send-email-andi@firstfloor.org>
Message-ID: <alpine.LFD.2.02.1109160126550.2723@ionos>
References: <1316117394-21666-1-git-send-email-andi@firstfloor.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Sep 2011, Andi Kleen wrote:

> This is a global tree sweep to fix up initconst section problems.
> 
> Any variable const in initdata must be marked __initconst, not initdata.
> const __read_mostly is not allowed.
> 
> Otherwise the global sections can get a read only marking and in some
> circumstances the compiler/and or the linker will detect conflicts.

In some circumstances?  Care to explain that in detail?
 
> This patchkit aims to fix it up everywhere.

Aims? How did you generate these patches? [grep|compile+look] and hack
or did you actually use something sensible like coccinelle?
 
> Also available in git://github.com/andikleen/linux-misc.git const-sections
> 
> Note I plan to ask Linus to pull this directly.

You can plan what you want, but unless you provide substantial
information please target your plan towards /dev/null

Thanks,

	tglx
