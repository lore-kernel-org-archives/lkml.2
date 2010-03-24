Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552Ab0CXKi2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 06:38:28 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:27028 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755482Ab0CXKiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 06:38:14 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v4 00/08] use lmb with x86
Date: Wed, 24 Mar 2010 03:34:13 -0700
Message-Id: <1269426861-20903-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4BA9EB0B.00A3,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

new early_res is lmb extension. and it could be used to replace bootmem.

even could share some code before bootmem, like register_active_region, and
lm_reserved_to_bootmem

add test version for powerpc

Thanks

Yinghai
