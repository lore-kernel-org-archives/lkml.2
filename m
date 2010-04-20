Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751661Ab0DTPJ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 11:09:28 -0400
Received: from kelvin.asmallorange.com ([207.210.111.10]:55918 "EHLO
	kelvin.asmallorange.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227Ab0DTPJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 11:09:26 -0400
X-Greylist: delayed 3541 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Apr 2010 11:09:26 EDT
Date: Tue, 20 Apr 2010 19:41:08 +0530
From: Rabin Vincent <rabin@rab.in>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>
Subject: Re: [Bug #15668] start_kernel(): bug: interrupts were enabled early
Message-ID: <20100420141108.GA2131@debian>
References: <deuQKFRcc0B.A.3EG.BRSzLB@tosh>
 <YeFfFNFyTSF.A.sj.BSSzLB@tosh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YeFfFNFyTSF.A.sj.BSSzLB@tosh>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - kelvin.asmallorange.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - rab.in
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 20, 2010 at 05:19:21AM +0200, Rafael J. Wysocki wrote:
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15668
> Subject		: start_kernel(): bug: interrupts were enabled early
> Submitter	: Rabin Vincent <rabin@rab.in>
> Date		: 2010-03-25 19:53 (26 days old)
> First-Bad-Commit: http://kernel.org/git/linus/773e3eb7b81e5ba13b5155dfb3bb75b8ce37f8f9
> Message-ID	: <20100325194100.GA2364@debian>
> References	: http://marc.info/?l=linux-kernel&m=126954607216519&w=2

This was fixed by 3eac4abaa69949af0e2f64e5c55ee8a22bbdd3e7 ("rwsem
generic spinlock: use IRQ save/restore spinlocks").

Rabin
