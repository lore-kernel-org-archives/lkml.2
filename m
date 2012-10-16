Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643Ab2JPSEb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 14:04:31 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:51438 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755372Ab2JPSE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 14:04:29 -0400
MIME-Version: 1.0
In-Reply-To: <CAMjP1K=WV=AJ=paz7uBJ2X0FnOX6Cf-HipWsFjLxicXGbvL6Sw@mail.gmail.com>
References: <CAMjP1K=WV=AJ=paz7uBJ2X0FnOX6Cf-HipWsFjLxicXGbvL6Sw@mail.gmail.com>
Date: Tue, 16 Oct 2012 21:04:28 +0300
X-Google-Sender-Auth: rwFW_2uY3GRJTk59wCo5sFz3x88
Message-ID: <CAOJsxLF2VJRRu_i2aCARwiw6knyrwL1HpZ1zGOASP133fNxv8Q@mail.gmail.com>
Subject: Re: Reading /proc/slabinfo causes stalls
From: Pekka Enberg <penberg@kernel.org>
To: Avleen Vig <avleen@gmail.com>
Cc: linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Avleen,

On Tue, Oct 16, 2012 at 8:51 PM, Avleen Vig <avleen@gmail.com> wrote:
> I *think* this is the right place to ask this, and apologies if it's not
> (is there a better place?).
>
> We have checks which read /proc/slabinfo once a minute, and have noticed
> that this causes the entire system to stall for a few milliseconds.
> It's long enough that it causes noticeable delays in latency-sensitive
> applications (between 10ms and 100ms).
>
> Is this a known condition? Are there work arounds or other ways to get the
> slab allocation data which don't cause stalls?

What kernel version are you using? What does your .config look like?
