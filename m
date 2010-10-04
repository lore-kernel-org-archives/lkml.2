Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479Ab0JDV6I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 17:58:08 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:40816 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab0JDV6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 17:58:06 -0400
Message-ID: <4CAA4DC1.6000104@kernel.org>
Date: Mon, 04 Oct 2010 14:57:21 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>, Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 0/4] memblock related fixes for -tip
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please check memblock related patches

[PATCH 1/4] memblock: Fix big size with find_region()
[PATCH -v5 2/4] x86, memblock: Fix crashkernel allocation
[PATCH 3/4] x86, memblock: Remove __memblock_x86_find_in_range_size()
[PATCH 4/4] x86, mm, memblock, 32bit: Make add_highpages honor early reserved ranges

first one should get into core/memblock branch, and others should be in x86/mm/memeblock branch

Thanks

Yinghai Lu
