Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758272Ab0IGUkk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 16:40:40 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:53475 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756244Ab0IGUki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 16:40:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/30] semaphore cleanup
Date: Tue, 7 Sep 2010 22:40:32 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc3-next-20100907+; KDE/4.5.1; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Hellwig <hch@infradead.org>
References: <20100907124636.880953480@linutronix.de> <201009071938.17681.arnd@arndb.de> <alpine.LFD.2.00.1009072219400.2477@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1009072219400.2477@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009072240.32807.arnd@arndb.de>
X-Provags-ID: V02:K0:0cq66QUWXjFWWNmh18g3RFnp1Ix19SK+EOxHKkeBUU3
 /4N77FZDWzjPn88+rqY6qxw7JYSgibOJa3LOlezqZtj/gtPzWW
 02/PggfnphDLfoxboACssjkg0xhGCOYydyqJUrZONwJJkwz4p8
 wRsve1pUnLS7urHQzS/9CdfLjnPoMUxCffHOQe9wE7ufLbllP0
 qQ/Lqkw4kpM6W1C7b+gog==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 September 2010 22:23:06 Thomas Gleixner wrote:
> sure, but most of them are really the init_MUTEX[_LOCKED] type which
> has been copied over and over again for almost a decade.
> 
> That's going away, so people are actually forced to look into the
> alternative solutions. And I do not worry too much about staging/*

Yes, good point.

	Arnd
