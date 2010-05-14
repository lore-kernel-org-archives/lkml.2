Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755713Ab0ENHHW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 03:07:22 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:46962 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093Ab0ENHHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 03:07:19 -0400
Message-ID: <4BECF5B8.1030503@oracle.com>
Date: Fri, 14 May 2010 00:03:20 -0700
From: Yinghai <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH 01/35] lmb: prepare x86 to use lmb to replace early_res
References: <1273796396-29649-1-git-send-email-yinghai@kernel.org>	 <1273796396-29649-2-git-send-email-yinghai@kernel.org> <1273803143.21352.353.camel@pasglop>
In-Reply-To: <1273803143.21352.353.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090203.4BECF66B.0094:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

updated version is in

	git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-2.6-yinghai.git lmb

it is on top of tip/master + powerpc/lmb
