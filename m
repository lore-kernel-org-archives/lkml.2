Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974Ab2HGNW7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 09:22:59 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:21690 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754952Ab2HGNW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 09:22:57 -0400
X-AuditID: cbfee61b-b7f566d000005c8a-4a-502116b03640
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: "'Aaro Koskinen'" <aaro.koskinen@iki.fi>,
        linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
References: <1344187926-22404-1-git-send-email-aaro.koskinen@iki.fi>
In-reply-to: <1344187926-22404-1-git-send-email-aaro.koskinen@iki.fi>
Subject: RE: [PATCH] ARM: dma-mapping: fix atomic allocation alignment
Date: Tue, 07 Aug 2012 15:22:47 +0200
Organization: SPRC
Message-id: <011d01cd749f$be649fa0$3b2ddee0$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1zMEI0a72l0JUtT3u6L7Ay+oxdBABbx+0Q
Content-language: pl
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsVy+t9jAd0NYooBBud3cltc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MOb9CC6axVKxc+YK1gXE1cxcjJ4eEgInE+oNfGCFsMYkL99az
	dTFycQgJLGKUuHN/LyuEM4tJ4uPObnaQKjYBQ4mut11gVSICbYwSl69OBWsXEnCReN64lg3E
	5hRwlZhz4AoTiC0s4CZx6cNmsHUsAqoSZ09eB6rn4OAXEJKYOEsBJMwL1Hp20wtGCFtQ4sfk
	eywgNrOAlsT6nceZIGx5ic1r3jKDtEoIqEs8+qsLEhYRMJL4s2g6O0SJiMTdhuesExiFZiGZ
	NAvJpFlIJs1C0rKAkWUVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnAYP5PewbiqweIQowAH
	oxIP70wVhQAh1sSy4srcQ4wSHMxKIryHdwKFeFMSK6tSi/Lji0pzUosPMUpzsCiJ85p4f/UX
	EkhPLEnNTk0tSC2CyTJxcEo1MNrdnfh219ZtJ1LW5Bq9vmu9XsrMXE7doV9k8Zud+k0TXW56
	7lLLebB9vWuG8d6p7MoG76cmtC0rWh539fmrn3duPBU1kJaqXXYo8Y66naLBu92/m7+v+rJg
	ZtPH6Z+CZ1mWXa48Hp86u2+inW1wrYx6tPAj7dS1AofXK4aySHbGHm7eUMVdd1+JpTgj0VCL
	uag4EQBe9mzYXwIAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Aaro,

On Sunday, August 05, 2012 7:32 PM Aaro Koskinen wrote:

> The alignment mask is calculated incorrectly. Fixing the calculation
> makes strange hangs/lockups disappear during the boot with Amstrad E3
> and 3.6-rc1 kernel.
> 
> Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>

Again, thanks for spotting and fixing the issue. I've applied it to my fixes branch. 
I'm really sorry for introducing such stupid bugs together with my changes.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


