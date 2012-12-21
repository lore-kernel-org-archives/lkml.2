Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328Ab2LUPjy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 10:39:54 -0500
Received: from www.linutronix.de ([62.245.132.108]:53089 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464Ab2LUPjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 10:39:46 -0500
Date: Fri, 21 Dec 2012 16:39:44 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Clark Williams <williams@redhat.com>
cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [ANNOUNCE] 3.6.11-rt24 (apocalypse release)c
In-Reply-To: <20121221092651.55b44bfb@redhat.com>
Message-ID: <alpine.LFD.2.02.1212211636460.3148@ionos>
References: <alpine.LFD.2.02.1212211413200.3148@ionos> <20121221092651.55b44bfb@redhat.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Dec 2012, Clark Williams wrote:
> I had to add this to get -rt24 to compile:
> +#include <linux/delay.h>

Carp. I should have run it through the full tests again after adding
that last minute fix yesterday night. But it was sooo obvious and of
course compiled with my config which magically pulls in that header.

I silently uploaded -rt25

Thanks,

	tglx
