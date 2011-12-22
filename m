Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536Ab1LVATv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 19:19:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33258 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754442Ab1LVATp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 19:19:45 -0500
Date: Wed, 21 Dec 2011 16:19:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: Michal Hocko <mhocko@suse.cz>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org,
        "Artem S. Tashkinov" <t.artem@mailcity.com>,
        Dave Jones <davej@redhat.com>, Alexey Dobriyan <adobriyan@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [resend PATCH for 3.2] procfs: do not confuse jiffies with
 cputime64_t
Message-Id: <20111221161944.ec1c49f9.akpm@linux-foundation.org>
In-Reply-To: <m2zkelo428.fsf@igel.home>
References: <m28vmi7ip3.fsf@igel.home>
	<201112120922.13633.arnd@arndb.de>
	<m21usavwi0.fsf_-_@igel.home>
	<20111212124333.GC14720@tiehlicka.suse.cz>
	<m2wra2uedy.fsf_-_@igel.home>
	<20111212131218.GD14720@tiehlicka.suse.cz>
	<20111221100334.GD27137@tiehlicka.suse.cz>
	<20111221115919.6beac46f.akpm@linux-foundation.org>
	<m28vm5pjrl.fsf@igel.home>
	<20111221155624.1555d8a4.akpm@linux-foundation.org>
	<m2zkelo428.fsf@igel.home>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Dec 2011 01:14:39 +0100
Andreas Schwab <schwab@linux-m68k.org> wrote:

> > a) what effect does this problem have upon users of the kernel?
> 
> get_idle_time returns the value in the wrong unit.

So the "idle" fields in /proc/stat are wrong.

We're getting there!  Now, in what way are they wrong?  How could a
kernel maintainer recognise that this patch is needed?

