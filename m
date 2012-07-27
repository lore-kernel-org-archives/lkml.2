Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418Ab2G0V2G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 17:28:06 -0400
Received: from gate.crashing.org ([63.228.1.57]:38784 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751820Ab2G0V2F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 17:28:05 -0400
Subject: Re: [PATCH v8 0/7] power management patch set
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <CADRPPNRxBJX3Wgkj2aPmw8w=Ayj57CTCOkTEwBDCKwbjein1Ew@mail.gmail.com>
Date: Fri, 27 Jul 2012 16:28:00 -0500
Cc: Zhao Chenhui <chenhui.zhao@freescale.com>, scottwood@freescale.com,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <B848F8F1-8FBC-46D8-B8FB-002077482E92@kernel.crashing.org>
References: <1342788159-27529-1-git-send-email-chenhui.zhao@freescale.com> <CADRPPNSw5Yn7EgHt5fm2vYr+zxC4T+JbsvT812u2JPKELNcA6g@mail.gmail.com> <B5854411-6C9A-43BA-BF5D-FB1AD76E28D1@kernel.crashing.org> <CADRPPNRxBJX3Wgkj2aPmw8w=Ayj57CTCOkTEwBDCKwbjein1Ew@mail.gmail.com>
To: Li Yang <leoli@freescale.com>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 26, 2012, at 10:14 PM, Li Yang wrote:

> On Fri, Jul 27, 2012 at 1:29 AM, Kumar Gala <galak@kernel.crashing.org> wrote:
>> 
>> On Jul 26, 2012, at 9:02 AM, Li Yang wrote:
>> 
>>> On Fri, Jul 20, 2012 at 8:42 PM, Zhao Chenhui
>>> <chenhui.zhao@freescale.com> wrote:
>>>> Changes for v8:
>>>> * Separated the cpu hotplug patch into three patches, as follows
>>>> [PATCH v8 1/7] powerpc/smp: use a struct epapr_spin_table to replace macros
>>>> [PATCH v8 2/7] powerpc/smp: add generic_set_cpu_up() to set cpu_state as CPU_UP_PREPARE
>>>> [PATCH v8 4/7] powerpc/85xx: add HOTPLUG_CPU support
>>>> 
>>>> * Replaced magic numbers with macros in "[PATCH 5/7] powerpc/85xx: add sleep and deep sleep support"
>>>> 
>>>> * no change to the rest of the patch set
>>> 
>>> Hi Kumar,
>>> 
>>> How about picking about this series for 3.6?  The review seems to
>>> settle down for this revision.
>> 
>> Its too late for 3.6, but will look at queuing it up for 3.7.
> 
> Too late?  The latest version were submitted on Jul 20 and you are
> still picking up other patches today.  :)  I do think the patches have
> been floating around for too long time to wait for another release
> cycle.  If there are problems, we can work on addressing them in
> follow up patches.

That's not how merge windows work.  The patches are merged when they are considered complete not when they are first posted.  The other patches I've applied are fixes for issues, not new functionality.  The new functionality is going into my 'next' branch.

- k

