Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234Ab0C3LVw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 07:21:52 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:32513 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809Ab0C3LVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 07:21:51 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v10 00/29] use lmb with x86
Date: Tue, 30 Mar 2010 04:19:34 -0700
Message-Id: <1269948003-17221-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4BB1DEB0.00D4,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the new lmb could be used to early_res in x86.

Suggested by: David, Ben, and Thomas

First one should go into 2.6.34

-v6: change sequence as requested by Thomas
-v7: seperate them to more patches
-v8: add boundary checking to make sure not free partial page.
-v9: use lmb_debug to control print out of reserve_lmb.
     add e820 clean up, and e820 become __initdata
-v10:use lmb.rmo_size and ARCH_DISCARD_LMB according to Michael
     change name to lmb_find_area/reserve_lmb_area/free_lmb_area, according to Michael
     update find_lmb_area to use __lmb_alloc_base according to ben

our orginal find_lmb_area is from low to high, but this __lmb_alloc_base is from
to low.

looks like it make bootmem have more segments

Please check

Thanks

Yinghai
