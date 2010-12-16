Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346Ab0LPKBU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 05:01:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63333 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754255Ab0LPKBN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 05:01:13 -0500
Date: Thu, 16 Dec 2010 11:00:50 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Vivek Goyal <vgoyal@redhat.com>,
        Maxim Uvarov <muvarov@gmail.com>, linux-kernel@vger.kernel.org,
        Neil Horman <nhorman@redhat.com>
Subject: Re: kdump broken on 2.6.37-rc4
Message-ID: <20101216100050.GA2261@redhat.com>
References: <20101208141942.GA2335@redhat.com>
 <4D00823A.9050808@kernel.org>
 <20101209124117.GA6032@redhat.com>
 <4D01377B.5070809@kernel.org>
 <20101213100848.GA2237@redhat.com>
 <4D0663F0.2060103@kernel.org>
 <4D06783C.6040009@zytor.com>
 <20101214224135.GB19693@redhat.com>
 <20101215103954.GA2243@redhat.com>
 <4D09958D.2040907@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D09958D.2040907@kernel.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 15, 2010 at 08:29:01PM -0800, Yinghai Lu wrote:
> please check
> 
> [PATCH] x86, crashkernel, 32bit: only try to get range under 512M
> 
> Steanishlaw report kdump is 32bit is broken.
LOL

> in misc.c for decompresser, it will do sanity checking to make sure heap
> heap under 512M.
> 
> So limit it in first kernel under 512M for 32bit system.
> 
> Reported-by: Stanislaw Gruszka <sgruszka@redhat.com>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Patch fix problem on my T-60 laptop.

As expected patch does not help on my other T-500 x86_64 system,
kdump not work there, but perhaps this is a different problem,
I'm going to check it.

Stanislaw
