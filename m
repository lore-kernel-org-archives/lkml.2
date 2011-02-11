Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932145Ab1BKA3D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 19:29:03 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46697 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757171Ab1BKA3C convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 19:29:02 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1102110058450.31804@localhost6.localdomain6>
References: <20110210222908.661199947@linutronix.de> <AANLkTi=waRQcvdxyKUgcLZ1r-hwUcAVZeVDcBa-apyK2@mail.gmail.com>
 <alpine.LFD.2.00.1102110058450.31804@localhost6.localdomain6>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 10 Feb 2011 16:28:08 -0800
Message-ID: <AANLkTin3o9eFjpe6TMmKb5LSRUT+0Y2EpD4OU4LzN8Kd@mail.gmail.com>
Subject: Re: [patch 00/75] genirq: Overhaul for 2.6.39
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, linux-arch@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 10, 2011 at 4:00 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>
>  29 files changed, 1353 insertions(+), 899 deletions(-)

So what is it that adds so many lines? Your description made me think
"cleanups", not "50% more code"

(Yeah, yeah, I could look at the code, but I also want to point out
that this really doesn't look like much of an improvement from a
high-level standpoint)

                             Linus
