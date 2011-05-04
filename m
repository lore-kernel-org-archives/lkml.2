Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784Ab1EDItc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 04:49:32 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:33531 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492Ab1EDIt3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 04:49:29 -0400
MIME-Version: 1.0
X-Originating-IP: [81.245.79.58]
In-Reply-To: <20110504015147.GB3165@Krystal>
References: <20110503231023.968960757@efficios.com>
	<20110503231428.245701713@efficios.com>
	<20110503172141.7d06fd7d@jbarnes-desktop>
	<20110504015147.GB3165@Krystal>
Date: Wed, 4 May 2011 10:49:28 +0200
Message-ID: <BANLkTinJAeFY5fFOprvvj2nSkN8cKfGvXA@mail.gmail.com>
Subject: Re: [RFC patch 25/32] trace event video gpu remove semicolons
From: Jean Pihet <jean.pihet@newoldbits.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Dave Airlie <airlied@redhat.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Li Zefan <lizf@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mathieu,

On Wed, May 4, 2011 at 3:51 AM, Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
> * Jesse Barnes (jbarnes@virtuousgeek.org) wrote:
>> On Tue, 03 May 2011 19:10:48 -0400
>> Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
>>
>> > Part of the gradual TRACE_EVENT() semicolon removal. Enables creation of array
>> > of events, thus saving space for trace event probes.
>> >
>> > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
>> > CC: Steven Rostedt <rostedt@goodmis.org>
>> > CC: Frederic Weisbecker <fweisbec@gmail.com>
>> > CC: Ingo Molnar <mingo@elte.hu>
>> > CC: Thomas Gleixner <tglx@linutronix.de>
>> > CC: Jesse Barnes <jbarnes@virtuousgeek.org>
>> > CC: Dave Airlie <airlied@redhat.com>
>> > CC: Chris Wilson <chris@chris-wilson.co.uk>
>> > CC: Li Zefan <lizf@cn.fujitsu.com>
>> > ---
>> >  drivers/gpu/drm/drm_trace.h       |    6 ++--
>> >  drivers/gpu/drm/i915/i915_trace.h |   52 +++++++++++++++++++-------------------
>> >  2 files changed, 29 insertions(+), 29 deletions(-)
There are radeon specific trace points defined in
drivers/gpu/drm/radeon/radeon_trace.h, which are not covered by this
patch.
Is it intentional?

Jean
