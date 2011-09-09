Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759973Ab1IIWlm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 18:41:42 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:24766 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759098Ab1IIWll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 18:41:41 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-10.tower-127.messagelabs.com!1315608099!16952239!2
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.3.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: <linux-sparse@vger.kernel.org>
Subject: improper sparse warnings in linux kernel build?
Date: Fri, 9 Sep 2011 15:41:28 -0700
User-Agent: KMail/1.9.9
CC: Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201109091541.28395.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

I'm not sure if this is the correct place to post this.  Please let me know.

I am seeing a lot of sparse warnings when compiling the linux kernel that
look like this:

arch/x86/kernel/cpu/mcheck/mce_intel.c:25:8:
  warning: symbol 'mce_banks_owned' was not declared. Should it be static?

This line in the code is:

static DEFINE_PER_CPU(mce_banks_t, mce_banks_owned);

I'm not really sure what the DEFINE_PER_CPU macro expands to so I'm not
sure if the 'static' in front is actually getting used or if sparse is just
confused.

Is this an actual problem in the linux kernel or is sparse just getting
tripped up by the DEFINE_PER_CPU macro?

Thanks,
Hartley
