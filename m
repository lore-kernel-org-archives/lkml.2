Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757346Ab0GNWAg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 18:00:36 -0400
Received: from www.tglx.de ([62.245.132.106]:43025 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756953Ab0GNWAf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 18:00:35 -0400
Date: Thu, 15 Jul 2010 00:00:07 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Joe Perches <joe@perches.com>
cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86 <x86@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch/x86/kernel/cpu/mtrr/cleanup.c: Use ";" not "," to
 terminate statements
In-Reply-To: <1279142828.5816.23.camel@Joe-Laptop.home>
Message-ID: <alpine.LFD.2.00.1007142347480.3321@localhost.localdomain>
References: <1279142828.5816.23.camel@Joe-Laptop.home>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jul 2010, Joe Perches wrote:

Sorry, but that's one of the most convoluted changelogs I ever saw. 

> These are the only "," terminated statements that
> precede a pr_<level> in the kernel tree.

Errm, why is this related to pr_<level> in any way ?
 
> These must be ";" terminated if the pr_<level>
> macros becomes a bit more space efficient using
> a "do { foo } while (0)" form.

It has absolutely _NOTHING_ to do with any implementation detail of
the function/macro which comes after those statements.

Terminating a statement with a comma is simply wrong by itself and it
needs to be fixed w/o further ado.

Thanks,

	tglx
