Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217Ab1JLTPg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 15:15:36 -0400
Received: from www.linutronix.de ([62.245.132.108]:33280 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365Ab1JLTPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 15:15:35 -0400
Date: Wed, 12 Oct 2011 21:15:34 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Nils Radtke <lkml@Think-Future.com>
cc: Linux Kernel-List <linux-kernel@vger.kernel.org>
Subject: Re: git checkout extraversion
In-Reply-To: <20111012190455.GC29770@localhost>
Message-ID: <alpine.LFD.2.02.1110122114110.3240@ionos>
References: <20111012190455.GC29770@localhost>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Oct 2011, Nils Radtke wrote:
>   Hi,
> 
>   Is it possible -- and if so: how? -- to checkout specific kernel extraversion?
> 
>   Example:
> 
>   git checkout -b my2.6.39.3 2.6.39.3
> 
>   This does not work as there's no such tag "2.6.39.3" (only "2.6.39").

You need to have the stable tree

    git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git

Linus tree does not contain the stable tags.

Thanks,

	tglx
