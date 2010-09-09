Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab0IIHPf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 03:15:35 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:43406 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256Ab0IIHPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 03:15:16 -0400
MIME-Version: 1.0
X-Originating-IP: [81.243.34.243]
In-Reply-To: <20100908065333.GG3439@elte.hu>
References: <AANLkTinUmbSUUuxUzc8++pcb9gd1CZFdyTQFrveTBXyV@mail.gmail.com>
	<20100908065333.GG3439@elte.hu>
Date: Thu, 9 Sep 2010 09:15:14 +0200
Message-ID: <AANLkTikpwSA411XRTi7Ybj_19URnW0mEMrf6pFYNpxVF@mail.gmail.com>
Subject: Re: [PATCH] tracing, perf: add more power related events
From: Jean Pihet <jean.pihet@newoldbits.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Renninger <trenn@suse.de>, Arjan van de Ven <arjan@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Len Brown <len.brown@intel.com>,
        arjan@infradead.org, Kevin Hilman <khilman@deeprootsystems.com>,
        linux-kernel@vger.kernel.org, discuss@lesswatts.org,
        linux-pm@lists.linux-foundation.org, linux-omap@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 8, 2010 at 8:53 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Jean Pihet <jean.pihet@newoldbits.com> wrote:
>
>> Hi,
>>
>> Here is a patch proposal for adding new trace events for power management.
>> Note: thread restarted after the initial discussions on LKML.
>
> Also mind including the ACPI tracepoints we talked about? That way a lot
> more people could test it, etc.
I think the ACPI tracepoints can be added on top of the proposed
patch. Is that ok?

Jean
