Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269Ab2GZR3d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 13:29:33 -0400
Received: from gate.crashing.org ([63.228.1.57]:42600 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486Ab2GZR3c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 13:29:32 -0400
Subject: Re: [PATCH v8 0/7] power management patch set
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <CADRPPNSw5Yn7EgHt5fm2vYr+zxC4T+JbsvT812u2JPKELNcA6g@mail.gmail.com>
Date: Thu, 26 Jul 2012 12:29:19 -0500
Cc: Zhao Chenhui <chenhui.zhao@freescale.com>, scottwood@freescale.com,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <B5854411-6C9A-43BA-BF5D-FB1AD76E28D1@kernel.crashing.org>
References: <1342788159-27529-1-git-send-email-chenhui.zhao@freescale.com> <CADRPPNSw5Yn7EgHt5fm2vYr+zxC4T+JbsvT812u2JPKELNcA6g@mail.gmail.com>
To: Li Yang <leoli@freescale.com>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 26, 2012, at 9:02 AM, Li Yang wrote:

> On Fri, Jul 20, 2012 at 8:42 PM, Zhao Chenhui
> <chenhui.zhao@freescale.com> wrote:
>> Changes for v8:
>> * Separated the cpu hotplug patch into three patches, as follows
>> [PATCH v8 1/7] powerpc/smp: use a struct epapr_spin_table to replace macros
>> [PATCH v8 2/7] powerpc/smp: add generic_set_cpu_up() to set cpu_state as CPU_UP_PREPARE
>> [PATCH v8 4/7] powerpc/85xx: add HOTPLUG_CPU support
>> 
>> * Replaced magic numbers with macros in "[PATCH 5/7] powerpc/85xx: add sleep and deep sleep support"
>> 
>> * no change to the rest of the patch set
> 
> Hi Kumar,
> 
> How about picking about this series for 3.6?  The review seems to
> settle down for this revision.

Its too late for 3.6, but will look at queuing it up for 3.7.

> Hi Scott,
> 
> Thanks for the review comments provided.  We'd like to get the ACK
> from you for the series if you can.
> 
> Regards,
> Leo

- k