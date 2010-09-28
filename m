Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757373Ab0I1RO1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 13:14:27 -0400
Received: from claw.goop.org ([74.207.240.146]:40738 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752082Ab0I1RO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 13:14:26 -0400
Message-ID: <4CA22270.2020305@goop.org>
Date: Tue, 28 Sep 2010 10:14:24 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: stefano.stabellini@eu.citrix.com, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        Stephen Tweedie <sct@redhat.com>
Subject: Re: [PATCH 12/12] xen/mtrr: Add mtrr_if support for Xen mtrr
References: <alpine.DEB.2.00.1009281217540.2864@kaball-desktop> <1285676218-26218-12-git-send-email-stefano.stabellini@eu.citrix.com> <20100928123925.GA18208@elte.hu>
In-Reply-To: <20100928123925.GA18208@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 09/28/2010 05:39 AM, Ingo Molnar wrote:
> * stefano.stabellini@eu.citrix.com <stefano.stabellini@eu.citrix.com> wrote:
>
>> From: Stephen Tweedie <sct@redhat.com>
>>
>> Add a Xen mtrr type, and reorganise mtrr initialisation slightly to
>> allow the mtrr driver to set up num_var_ranges (Xen needs to do this by
>> querying the hypervisor itself.)
>>
>> [ Impact: add basic MTRR support ]
>>
>> Signed-off-by: Stephen Tweedie <sct@redhat.com>
>> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
>> ---
>>  arch/x86/kernel/cpu/mtrr/Makefile |    2 +-
>>  arch/x86/kernel/cpu/mtrr/main.c   |    3 +
>>  arch/x86/kernel/cpu/mtrr/mtrr.h   |    7 ++
>>  arch/x86/kernel/cpu/mtrr/xen.c    |  110 +++++++++++++++++++++++++++++++++++++
>>  4 files changed, 121 insertions(+), 1 deletions(-)
>>  create mode 100644 arch/x86/kernel/cpu/mtrr/xen.c
> Still NAK, for the very same reasons as we NAK-ed it the previous time: 
> /proc/mtrr is a problematic and complicated legacy interface that should 
> die.

Is your objection because we're adding a Xen mtrr implementation at all,
or because we're (slightly) extending the mtrr interface to do it?

Thanks,
    J
