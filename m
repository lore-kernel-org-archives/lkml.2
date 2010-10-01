Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188Ab0JASOZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 14:14:25 -0400
Received: from mail.fem.tu-ilmenau.de ([141.24.101.79]:37170 "EHLO
	mail.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811Ab0JASOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 14:14:24 -0400
From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
To: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: 2.6.36-rc5 i915 regression
Date: Fri, 1 Oct 2010 20:15:18 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc6+; KDE/4.5.1; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <201010011300.06298.johannes.hirte@fem.tu-ilmenau.de> <89k77n$p3lgk1@fmsmga001.fm.intel.com>
In-Reply-To: <89k77n$p3lgk1@fmsmga001.fm.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201010012015.19272.johannes.hirte@fem.tu-ilmenau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 October 2010 14:28:25 Chris Wilson wrote:
> On Fri, 1 Oct 2010 13:00:05 +0200, Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de> wrote:
> > With 2.6.36-rc5 and later my netbook is unusable. After login on X (KDE) the
> > screen gets totally garbled, under X and console too. The log shows me this
> > messages:
> 
> My humble apologies, fixed in 2.6.36-rc6:
> 
> commit 9b74f7348f214b1f99819f0d0da4a1cbabb1e740
> Author: Chris Wilson <chris@chris-wilson.co.uk>
> Date:   Wed Sep 22 19:10:44 2010 +0100
> 
>     drm/i915: Fix 945GM regression in e259befd
>     
>     A minor typo caused a single fence register to be incorrectly
>     programmed, resulting in occassional tiling corruption.
>     
>     Reported-and-tested-by: Hans de Bruin <bruinjm@xs4all.nl>
>     Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=18962
>     Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
>     Cc: stable@kernel.org
> 
> It appears to have bitten worse than just the occasional gfx corruption.
> -Chris

I was sure that I've tested latest git before reporting this bug, but obviously
I didn't. With latest git the bug seems to be fixed. Sorry for the noise.

regards,
  Johannes
