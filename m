Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418Ab1AKI12 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 03:27:28 -0500
Received: from www.tglx.de ([62.245.132.106]:39436 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754363Ab1AKI1V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 03:27:21 -0500
Date: Tue, 11 Jan 2011 09:26:48 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andi@firstfloor.org, johnstul@us.ibm.com, williams@redhat.com,
        schwidefsky@de.ibm.com, mingo@elte.hu,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/tsc] x86: Improve TSC calibration using a delayed
 workqueue
In-Reply-To: <20110111081352.GA22867@shutemov.name>
Message-ID: <alpine.LFD.2.00.1101110926040.12146@localhost6.localdomain6>
References: <1289003985-29060-1-git-send-email-johnstul@us.ibm.com> <tip-08ec0c58fb8a05d3191d5cb6f5d6f81adb419798@git.kernel.org> <20110111081352.GA22867@shutemov.name>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Jan 2011, Kirill A. Shutemov wrote:

> On Sun, Dec 05, 2010 at 11:18:53AM +0000, tip-bot for John Stultz wrote:
> > Commit-ID:  08ec0c58fb8a05d3191d5cb6f5d6f81adb419798
> > Gitweb:     http://git.kernel.org/tip/08ec0c58fb8a05d3191d5cb6f5d6f81adb419798
> > Author:     John Stultz <johnstul@us.ibm.com>
> > AuthorDate: Tue, 27 Jul 2010 17:00:00 -0700
> > Committer:  John Stultz <john.stultz@linaro.org>
> > CommitDate: Thu, 2 Dec 2010 16:48:37 -0800
> > 
> > x86: Improve TSC calibration using a delayed workqueue
> 
> This commit breaks booting the kernel in qemu with enabled KVM on my machine.
> .config attached.
> 
> [    0.424013] divide error: 0000 [#1] 

Got fixed by a8760ec (x86: Check tsc available/disabled in the delayed
init function)

Thanks,

	tglx
