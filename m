Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867Ab1HBBDC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 21:03:02 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53051 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753355Ab1HBBC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 21:02:57 -0400
Message-ID: <4E374C9E.5000102@zytor.com>
Date: Mon, 01 Aug 2011 18:02:22 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] x86/spinlocks optional for 3.1
References: <201108011753.p71HrrTr011226@hera.kernel.org> <CA+55aFyKFP3KzVfSEO02TjjmMDDL5agCJjKERFdmStM4k9DtQQ@mail.gmail.com>
In-Reply-To: <CA+55aFyKFP3KzVfSEO02TjjmMDDL5agCJjKERFdmStM4k9DtQQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2011 05:04 PM, Linus Torvalds wrote:
> 
> If that xadd implementation could perhaps be shared, I wouldn't hate
> it so much. As it is, I really don't see the point in pulling this.
> 

OK, no problem.  We'll rework it for 3.2.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

