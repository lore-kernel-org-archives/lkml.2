Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640Ab0IOPpX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 11:45:23 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:46804 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754508Ab0IOPpS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 11:45:18 -0400
MIME-Version: 1.0
X-Originating-IP: [87.66.152.179]
In-Reply-To: <20100909075403.GA10798@elte.hu>
References: <AANLkTinUmbSUUuxUzc8++pcb9gd1CZFdyTQFrveTBXyV@mail.gmail.com>
	<20100908065333.GG3439@elte.hu>
	<AANLkTikpwSA411XRTi7Ybj_19URnW0mEMrf6pFYNpxVF@mail.gmail.com>
	<20100909075403.GA10798@elte.hu>
Date: Wed, 15 Sep 2010 17:45:09 +0200
Message-ID: <AANLkTimCy8pB6JZ2bkGutTou8-oXc1yjweqCxVrLw=Kk@mail.gmail.com>
Subject: Re: [PATCH] tracing, perf: add more power related events
From: Jean Pihet <jean.pihet@newoldbits.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Renninger <trenn@suse.de>, Arjan van de Ven <arjan@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Len Brown <len.brown@intel.com>,
        arjan@infradead.org, Kevin Hilman <khilman@deeprootsystems.com>,
        linux-kernel@vger.kernel.org, discuss@lesswatts.org,
        linux-pm@lists.linux-foundation.org, linux-omap@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 9, 2010 at 9:54 AM, Ingo Molnar <mingo@elte.hu> wrote:
>> I think the ACPI tracepoints can be added on top of the proposed
>> patch. Is that ok?
>
> Yeah - and the OMAP thing can be split up too if the OMAP folks prefer
> it that way, but we still want to _see_ all the patches in this thread
> together so that we have a critical mass of people interested in all
> this ...

Any chance to get the patch merged in?
What is needed wrt to ACPI support?

>
> Thanks,
>
>        Ingo

Thanks,
Jean
