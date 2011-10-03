Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932219Ab1JCP3P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 11:29:15 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58246 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756067Ab1JCP3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 11:29:09 -0400
MIME-Version: 1.0
In-Reply-To: <1317461738.3375.46.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1317395577-14091-1-git-send-email-matt@console-pimps.org>
 <m21uuxirxi.fsf@firstfloor.org> <1317461738.3375.46.camel@mfleming-mobl1.ger.corp.intel.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 3 Oct 2011 08:28:48 -0700
X-Google-Sender-Auth: nq8PTqnVUpNPTWHv3Tzq65MaBDA
Message-ID: <CA+55aFyscb=PcUDrEUhFbH89+W-KYEKrqKHeNN3dqmZD1GF_Hw@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/5] Signal scalability series
To: Matt Fleming <matt@console-pimps.org>
Cc: Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Tony Luck <tony.luck@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Mosberger-Tang <davidm@egauge.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 1, 2011 at 2:35 AM, Matt Fleming <matt@console-pimps.org> wrote:
>
> You and me both. Unfortunately, the ia64 guys had a different opinion,
> http://www.spinics.net/lists/linux-ia64/msg08363.html

Well, considering that it apparently slows down the single-threaded
case by 50% on an architecture that actually *matters*, I think the
whole discussion is somewhat academic, don't you?

"Scalability" is pretty much never a valid excuse for "slows down the
common case".

                       Linus
