Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211Ab0D0Pj6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 11:39:58 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:59552 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754033Ab0D0Pj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 11:39:57 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: =?utf-8?q?J=C3=B6rn_Engel?= <joern@logfs.org>
Subject: Re: [PATCH 1/7] logfs: push down BKL into ioctl function
Date: Tue, 27 Apr 2010 17:38:50 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: John Kacur <jkacur@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jan Blunck <jblunck@gmail.com>, Thomas Gleixner <tglx@linutronix.de>
References: <alpine.LFD.2.00.1004271359180.3318@localhost> <alpine.LFD.2.00.1004271725490.3318@localhost> <20100427153209.GD16794@logfs.org>
In-Reply-To: <20100427153209.GD16794@logfs.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201004271738.50505.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+LWPJhvCTW9g+olsqvrfKNNym5QRqrsyrL5+j
 Dr3458pWk0QsErxiGCRqDovtJkESwmABP5gflk2Ks8pfq4SsoD
 QsgGaC3g1/qXMq3QLeIkg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 April 2010, Jörn Engel wrote:
> On Tue, 27 April 2010 17:27:19 +0200, John Kacur wrote:
> > 
> > Hasn't the "current" merge window been over with for weeks? I was assuming 
> > that bkl push down, or other bkl patches are for the next merge window.
> 
> That's what I was thinking.  But some of the bkl related discussion gave
> me the impression that such patches were still being merged.  So I
> wanted to be sure.

Yes, just queue it for the 2.6.35-rc1 window and make sure it shows up in
linux-next, or send a replacement patch with your Ack or S-o-b so we can
put it into the BKL queue.

	Arnd
