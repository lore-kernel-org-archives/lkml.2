Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191Ab1KAXzw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 19:55:52 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62865 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832Ab1KAXzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 19:55:51 -0400
MIME-Version: 1.0
In-Reply-To: <CAGjg+kFyqWa=Ui+XRDoCvYFLt7eH-vScFk24tk1aZJkfWRMOxQ@mail.gmail.com>
References: <1316804080-6396-1-git-send-email-venki@google.com>
	<CAGjg+kH577VE4cyq5zVNR962S6xbGCNnGS0w6N1DVuOppL3Khw@mail.gmail.com>
	<CABeCy1Y_OXPJkca6dRvK4-PCfKH8wD_2Aq-9r-JyBBSCetrsOw@mail.gmail.com>
	<CAGjg+kFyqWa=Ui+XRDoCvYFLt7eH-vScFk24tk1aZJkfWRMOxQ@mail.gmail.com>
Date: Tue, 1 Nov 2011 16:55:50 -0700
Message-ID: <CABeCy1aFW7z+-s2m-Fx6Fhcj7Dpa3Mm5hEh7fPiD3_CxFdQbPA@mail.gmail.com>
Subject: Re: [RFC] Introduce greedy hrtimer walk on idle
From: Venki Pallipadi <venki@google.com>
To: alex shi <lkml.alex@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel@vger.kernel.org, "Chen, Tim C" <tim.c.chen@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 31, 2011 at 7:11 PM, alex shi <lkml.alex@gmail.com> wrote:
>> Hi Alex,
>>
>> It should apply cleanly over 3.0. Thanks for testing the patch..
>
> I tested the patch against 3.1 kernel for specpower benchmark on our
> machine, westmere core laptop Thinkpad t410(internal name lkp-t410),
> and on Romely-EP machine(lkp-sb03). No clear power or performance
> change found. the performance and power has no clear change for every
> level system load. from 0 to 100%.

Thanks Alex for testing this. Likely that with specpower there are not
many active timers. Was the run with run level 5 and with all the system daemons
that come with distro active?

Thanks,
Venki
