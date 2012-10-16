Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921Ab2JPTFB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 15:05:01 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:47173 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755889Ab2JPTE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 15:04:59 -0400
MIME-Version: 1.0
In-Reply-To: <0000013a6aee372f-add43c34-0cc1-4cdb-8ad1-730074b2b49b-000000@email.amazonses.com>
References: <CAMjP1K=WV=AJ=paz7uBJ2X0FnOX6Cf-HipWsFjLxicXGbvL6Sw@mail.gmail.com>
	<CAOJsxLF2VJRRu_i2aCARwiw6knyrwL1HpZ1zGOASP133fNxv8Q@mail.gmail.com>
	<0000013a6ad64c95-106bab18-5a15-4c85-bae9-5527aa52f661-000000@email.amazonses.com>
	<alpine.DEB.2.00.1210161147410.2910@chino.kir.corp.google.com>
	<0000013a6aee372f-add43c34-0cc1-4cdb-8ad1-730074b2b49b-000000@email.amazonses.com>
Date: Tue, 16 Oct 2012 14:04:58 -0500
Message-ID: <CAMjP1K=vWLNqOjgwnvq9NfWU2af-M7+CFMtp9naraFO+Xmod6A@mail.gmail.com>
Subject: Re: Reading /proc/slabinfo causes stalls
From: Avleen Vig <avleen@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>, Pekka Enberg <penberg@kernel.org>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2012 at 1:55 PM, Christoph Lameter <cl@linux.com> wrote:
> On Tue, 16 Oct 2012, David Rientjes wrote:
>
>> Or convert slab_mutex to be a rwlock?
>
> The RT folks just converted it to a mutex.... ;-)

Damn :-)

I'll play around with SLUB.
There were some concerns that it doesn't perform as well as SLAB on
large hardware (we're almost always running >16G RAM, and regularly
>96G RAM on things like memcache servers).
If the performance pans out, SLUB would be great.
