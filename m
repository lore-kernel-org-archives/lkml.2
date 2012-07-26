Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181Ab2GZOCC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 10:02:02 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37355 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab2GZOCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 10:02:00 -0400
MIME-Version: 1.0
In-Reply-To: <1342788159-27529-1-git-send-email-chenhui.zhao@freescale.com>
References: <1342788159-27529-1-git-send-email-chenhui.zhao@freescale.com>
Date: Thu, 26 Jul 2012 22:02:00 +0800
X-Google-Sender-Auth: eJRYHZUKy3o0afk1vDIHnhEqHW8
Message-ID: <CADRPPNSw5Yn7EgHt5fm2vYr+zxC4T+JbsvT812u2JPKELNcA6g@mail.gmail.com>
Subject: Re: [PATCH v8 0/7] power management patch set
From: Li Yang <leoli@freescale.com>
To: Zhao Chenhui <chenhui.zhao@freescale.com>, scottwood@freescale.com,
        galak@kernel.crashing.org
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2012 at 8:42 PM, Zhao Chenhui
<chenhui.zhao@freescale.com> wrote:
> Changes for v8:
> * Separated the cpu hotplug patch into three patches, as follows
>   [PATCH v8 1/7] powerpc/smp: use a struct epapr_spin_table to replace macros
>   [PATCH v8 2/7] powerpc/smp: add generic_set_cpu_up() to set cpu_state as CPU_UP_PREPARE
>   [PATCH v8 4/7] powerpc/85xx: add HOTPLUG_CPU support
>
> * Replaced magic numbers with macros in "[PATCH 5/7] powerpc/85xx: add sleep and deep sleep support"
>
> * no change to the rest of the patch set

Hi Kumar,

How about picking about this series for 3.6?  The review seems to
settle down for this revision.


Hi Scott,

Thanks for the review comments provided.  We'd like to get the ACK
from you for the series if you can.

Regards,
Leo
