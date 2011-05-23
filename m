Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958Ab1EWAmp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 20:42:45 -0400
Received: from waste.org ([173.11.57.241]:42659 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755608Ab1EWAmn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 20:42:43 -0400
Subject: Re: Regression with i915 and suspend on Thinkpad x220
From: Matt Mackall <mpm@selenic.com>
To: Keith Packard <keithp@keithp.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <yunipt2730l.fsf@aiko.keithp.com>
References: <1306040157.3322.11.camel@calx>
	 <yunlixz6yop.fsf@aiko.keithp.com> <1306078089.4204.1.camel@calx>
	 <yunipt2730l.fsf@aiko.keithp.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 22 May 2011 19:42:42 -0500
Message-ID: <1306111362.4204.17.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-05-22 at 16:02 -0700, Keith Packard wrote:
> On Sun, 22 May 2011 10:28:09 -0500, Matt Mackall <mpm@selenic.com> wrote:
> 
> > Appears to work, thanks.
> 
> Thanks for testing this.
> 
> Jesse and Chris: would be best to figure out what's going on here if
> possible, otherwise we should consider submitting an FBC disable patch
> for SNB to stable@
> 
> Matt: sounds like your machine can reliably reproduce this problem; if
> we come up with an alternate patch which re-enables FBC, would you be
> willing to give it a try?

Sure.


-- 
Mathematics is the supreme nostalgia of our time.


