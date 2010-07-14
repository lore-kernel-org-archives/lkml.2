Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757987Ab0GNWWd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 18:22:33 -0400
Received: from mail.perches.com ([173.55.12.10]:1893 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754522Ab0GNWWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 18:22:32 -0400
Subject: Re: [PATCH] arch/x86/kernel/cpu/mtrr/cleanup.c: Use ";" not "," to
 terminate statements
From: Joe Perches <joe@perches.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86 <x86@kernel.org>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.2.00.1007142347480.3321@localhost.localdomain>
References: <1279142828.5816.23.camel@Joe-Laptop.home>
	 <alpine.LFD.2.00.1007142347480.3321@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Jul 2010 15:22:29 -0700
Message-ID: <1279146149.5816.53.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-15 at 00:00 +0200, Thomas Gleixner wrote:
> On Wed, 14 Jul 2010, Joe Perches wrote:
> that's one of the most convoluted changelogs I ever saw. 
> > These are the only "," terminated statements that
> > precede a pr_<level> in the kernel tree.
> Terminating a statement with a comma is simply wrong by itself and it
> needs to be fixed w/o further ado.

Great.  So remove the changelog and just use the subject.

I sent a simpler changelog patch last month.
http://lkml.org/lkml/2010/6/28/349

Ingo rejected it.

He said there were other style problems in the file that
needed cleaning.  I asked what those style problems were.
checkpatch and his "code-quality" script don't show
significant issues.  No reply from Ingo.


