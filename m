Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab1D3UPR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 16:15:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33834 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752015Ab1D3UPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 16:15:15 -0400
Message-ID: <4DBC6DC1.30900@redhat.com>
Date: Sat, 30 Apr 2011 23:14:57 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/2] x2apic optimization, round 4
References: <20110430171459.685415696@openvz.org>
In-Reply-To: <20110430171459.685415696@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2011 08:14 PM, Cyrill Gorcunov wrote:
>    Hi Ingo, here is an updated series of two patches for
> x2apic cluster mode ipi optimization. Please take a
> look.
>
>    The only concern which was unresolved is a messy bit
> in default_setup_apic_routing(), so we've added a FIXME
> there and clean it up as only time permits. Actually I
> have a plan to merge probe_32/64.c into single file (and
> even started working on this task) but not yes succeed.
>
>    Anyway I think patches should be in a good shape now and
> probably we could merge them to not lose?
>
>    Comments are welcome.

Very nice!  This will also significantly speed up kvm guests using x2apic.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

