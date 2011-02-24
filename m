Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932679Ab1BXHMx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 02:12:53 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:53838 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932649Ab1BXHMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 02:12:50 -0500
Message-ID: <4D6604A8.1010001@kernel.org>
Date: Wed, 23 Feb 2011 23:11:36 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        David Miller <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] mm: Split bootmem.c for nobootmem support
References: <1297120632-24933-1-git-send-email-yinghai@kernel.org>	<1297120632-24933-11-git-send-email-yinghai@kernel.org> <20110222154806.0be18267.akpm@linux-foundation.org>
In-Reply-To: <20110222154806.0be18267.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4D6604D8.00B4,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resubmit for put into tip tree, with Andrew's Acked-by.

Those three patches could be applied to current Linus tree cleanly. So could be in separated tip/mm branch?

Thanks

Yinghai
