Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114Ab1HPVjN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 17:39:13 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35302 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054Ab1HPVjL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 17:39:11 -0400
MIME-Version: 1.0
Reply-To: linasvepstas@gmail.com
In-Reply-To: <20110816192918.GC2803@mtj.dyndns.org>
References: <20110816190858.GA4890@redhat.com> <CAHrUA357c2eCq=VkZwL97-nK7Kopzfj84gSESxebhL_P7rCurw@mail.gmail.com>
 <20110816192918.GC2803@mtj.dyndns.org>
From: Linas Vepstas <linasvepstas@gmail.com>
Date: Tue, 16 Aug 2011 16:38:50 -0500
Message-ID: <CAHrUA37p7yqbEG3vU-cV3fM=-MO+6VEs5CebyhdJJodwfKQbRA@mail.gmail.com>
Subject: Re: [PATCH] powerpc/eeh: remove eeh_event_handler()->daemonize()
To: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 August 2011 14:29, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On Tue, Aug 16, 2011 at 02:24:12PM -0500, Linas Vepstas wrote:
>> BTW, if someone wants to tackle a big, difficult project, one would be
>> to untangle the mess that happens when the hardware underneath an
>> active block device dies.  Currently, the kernel will deadlock in
>> umpteen zillion places waiting for blocks and files that will never
>> arrive.
>
> Umm... that has been working fine for SCSI and ATA for years now.
> Just aborting pending commands and freeing the device should do it.
> Drivers need to take care of driver specific resources (per-req and
> per-dev) but that's not different from aborting timed out commands.
> What's missing for your use case?

Sorry, I guess I'm out-of-date; its been far more than a few years since
I last tried this :-) The use case was eeh recovery, where the hardware was
so hosed that it wouldn't recover.  The test cases were whatever it was that
the test team could throw at the system.

--linas

--linas
