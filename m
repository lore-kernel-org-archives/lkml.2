Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216Ab0L1AuL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 19:50:11 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:32102 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903Ab0L1AtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 19:49:13 -0500
Message-ID: <4D1933B0.90207@kernel.org>
Date: Mon, 27 Dec 2010 16:47:44 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/6] memblock related further cleanup for x86
References: <4D0C072D.1040201@kernel.org>
In-Reply-To: <4D0C072D.1040201@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please check

Those 6 patches need to be applied after three patches that i sent out 12/17/2010.

it will put page table in local node memory for 64bit numa.

Thanks

Yinghai

