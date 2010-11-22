Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755681Ab0KVMYB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 07:24:01 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46811 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755510Ab0KVMX7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 07:23:59 -0500
MIME-Version: 1.0
X-Originating-IP: [192.102.204.37]
In-Reply-To: <1290077254-12165-4-git-send-email-andi@firstfloor.org>
References: <1290077254-12165-1-git-send-email-andi@firstfloor.org>
	<1290077254-12165-4-git-send-email-andi@firstfloor.org>
Date: Mon, 22 Nov 2010 20:23:43 +0800
Message-ID: <AANLkTinFxc5R-CgWv3XnoDrBcwQv_zwz1_4oCwTOOqGh@mail.gmail.com>
Subject: Re: [PATCH 3/4] perf-events: Add support for supplementary event
 registers v3
From: Lin Ming <lin@ming.vg>
To: Andi Kleen <andi@firstfloor.org>
Cc: a.p.zijlstra@chello.nl, eranian@google.com, linux-kernel@vger.kernel.org,
        x86@kernel.org, Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 6:47 PM, Andi Kleen <andi@firstfloor.org> wrote:
> From: Andi Kleen <ak@linux.intel.com>
>
> Intel Nehalem/Westmere have a special OFFCORE_RESPONSE event
> that can be used to monitor any offcore accesses from a core.
> This is a very useful event for various tunings, and it's
> also needed to implement the generic LLC-* events correctly.
>
> Unfortunately this event requires programming a mask in a separate
> register. And worse this separate register is per core, not per
> CPU thread.

This "separate register" is MSR_OFFCORE_RSP_0, right?
But from the SDM,  MSR_OFFCORE_RSP_0 is "thread" scope,
see SDM 3b, Appendix B.4 MSRS IN THE INTEL® MICROARCHITECTURE CODENAME NEHALEM

Or am I missing some obvious thing?

Thanks,
Lin Ming
