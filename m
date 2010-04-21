Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868Ab0DUFDP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 01:03:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53848 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751058Ab0DUFDN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 01:03:13 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Rabin Vincent <rabin@rab.in>
Subject: Re: [Bug #15668] start_kernel(): bug: interrupts were enabled early
Date: Wed, 21 Apr 2010 07:04:09 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc4-rjw; KDE/4.3.5; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>
References: <deuQKFRcc0B.A.3EG.BRSzLB@tosh> <YeFfFNFyTSF.A.sj.BSSzLB@tosh> <20100420141108.GA2131@debian>
In-Reply-To: <20100420141108.GA2131@debian>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004210704.09668.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 April 2010, Rabin Vincent wrote:
> On Tue, Apr 20, 2010 at 05:19:21AM +0200, Rafael J. Wysocki wrote:
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15668
> > Subject		: start_kernel(): bug: interrupts were enabled early
> > Submitter	: Rabin Vincent <rabin@rab.in>
> > Date		: 2010-03-25 19:53 (26 days old)
> > First-Bad-Commit: http://kernel.org/git/linus/773e3eb7b81e5ba13b5155dfb3bb75b8ce37f8f9
> > Message-ID	: <20100325194100.GA2364@debian>
> > References	: http://marc.info/?l=linux-kernel&m=126954607216519&w=2
> 
> This was fixed by 3eac4abaa69949af0e2f64e5c55ee8a22bbdd3e7 ("rwsem
> generic spinlock: use IRQ save/restore spinlocks").

Thanks, closed.

Rafael
