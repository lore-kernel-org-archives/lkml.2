Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283Ab2G0DO3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 23:14:29 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:42601 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410Ab2G0DO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 23:14:28 -0400
MIME-Version: 1.0
In-Reply-To: <B5854411-6C9A-43BA-BF5D-FB1AD76E28D1@kernel.crashing.org>
References: <1342788159-27529-1-git-send-email-chenhui.zhao@freescale.com>
	<CADRPPNSw5Yn7EgHt5fm2vYr+zxC4T+JbsvT812u2JPKELNcA6g@mail.gmail.com>
	<B5854411-6C9A-43BA-BF5D-FB1AD76E28D1@kernel.crashing.org>
Date: Fri, 27 Jul 2012 11:14:27 +0800
X-Google-Sender-Auth: -_232ccn_k67vlSeQuY3ySXZ3rI
Message-ID: <CADRPPNRxBJX3Wgkj2aPmw8w=Ayj57CTCOkTEwBDCKwbjein1Ew@mail.gmail.com>
Subject: Re: [PATCH v8 0/7] power management patch set
From: Li Yang <leoli@freescale.com>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Zhao Chenhui <chenhui.zhao@freescale.com>, scottwood@freescale.com,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2012 at 1:29 AM, Kumar Gala <galak@kernel.crashing.org> wrote:
>
> On Jul 26, 2012, at 9:02 AM, Li Yang wrote:
>
>> On Fri, Jul 20, 2012 at 8:42 PM, Zhao Chenhui
>> <chenhui.zhao@freescale.com> wrote:
>>> Changes for v8:
>>> * Separated the cpu hotplug patch into three patches, as follows
>>> [PATCH v8 1/7] powerpc/smp: use a struct epapr_spin_table to replace macros
>>> [PATCH v8 2/7] powerpc/smp: add generic_set_cpu_up() to set cpu_state as CPU_UP_PREPARE
>>> [PATCH v8 4/7] powerpc/85xx: add HOTPLUG_CPU support
>>>
>>> * Replaced magic numbers with macros in "[PATCH 5/7] powerpc/85xx: add sleep and deep sleep support"
>>>
>>> * no change to the rest of the patch set
>>
>> Hi Kumar,
>>
>> How about picking about this series for 3.6?  The review seems to
>> settle down for this revision.
>
> Its too late for 3.6, but will look at queuing it up for 3.7.

Too late?  The latest version were submitted on Jul 20 and you are
still picking up other patches today.  :)  I do think the patches have
been floating around for too long time to wait for another release
cycle.  If there are problems, we can work on addressing them in
follow up patches.

Leo
