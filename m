Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756387Ab0DAMwR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 08:52:17 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:59789 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756112Ab0DAMwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 08:52:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC 0/9] BKL conversion in TTY drivers
Date: Thu, 1 Apr 2010 14:51:59 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>
References: <1269982580-9361-1-git-send-email-arnd@arndb.de> <201003310957.03025.arnd@arndb.de> <20100331110228.2443ccd6@lxorguk.ukuu.org.uk>
In-Reply-To: <20100331110228.2443ccd6@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004011451.59712.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+7waWyOXj/sZhhveCJbR+5ptTrMmk1kEvaOgH
 kqVejFYHwgX1LxynrgTGuG7pypxZpxYAW6f7ANOEPtHnyWtBsy
 kUpCyFgsIZQM6wZkkIPgQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 31 March 2010, Alan Cox wrote:
> > Are you more worried that the interface conversion (patches 1-8)
> > can introduce bugs and make your life harder, or that the mutex
> > based implementation from patch 9 causes problems that were previously
> > hidden by other bugs?
> 
> It doesn't really make any difference to me - I'm either removing the BKL
> or the BKM.

Ok, great! 

Greg, are you ok with merging these TTY patches in your tree for 2.6.35
then? There will be at least one more respin of it for minor changes
and anything that comes up during testing, but it's essentially what I
posted here.

	Arnd
