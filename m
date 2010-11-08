Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab0KHQr5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 11:47:57 -0500
Received: from www.tglx.de ([62.245.132.106]:37901 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752629Ab0KHQr4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 11:47:56 -0500
Date: Mon, 8 Nov 2010 17:47:19 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Darren Hart <dvhart@linux.intel.com>
cc: linux-kernel@vger.kernel.org, Matt Fleming <matt@console-pimps.org>,
        peterz@infradead.org, mingo@elte.hu, eric.dumazet@gmail.com,
        jkacur@redhat.com
Subject: Re: [PATCH 2/3] futex: replace fshared and clockrt with combined
 flags
In-Reply-To: <1288216466-14309-3-git-send-email-dvhart@linux.intel.com>
Message-ID: <alpine.LFD.2.00.1011081745520.2900@localhost6.localdomain6>
References: <1288216466-14309-1-git-send-email-dvhart@linux.intel.com> <1288216466-14309-3-git-send-email-dvhart@linux.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Oct 2010, Darren Hart wrote:
> -static int futex_wake(u32 __user *uaddr, int fshared, int nr_wake, u32 bitset)
> +static int futex_wake(u32 __user *uaddr, int flags, int nr_wake, u32 bitset)

Can we make the flags unsigned please ?

Aside of that it'd be nice to split out the patches which cleanup the
functions which do not use fshared anymore.

Thanks,

	tglx
