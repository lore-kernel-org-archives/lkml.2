Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751668Ab0HTAwP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 20:52:15 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:47381 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539Ab0HTAwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 20:52:13 -0400
Message-ID: <4C6DD170.1060807@renesas.com>
Date: Fri, 20 Aug 2010 09:50:56 +0900
From: Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.11) Gecko/20100711 Lightning/1.0b1 Thunderbird/3.0.6
MIME-Version: 1.0
To: Brian Norris <norris@broadcom.com>
CC: linux-mtd@lists.infradead.org, Sneha Narnakaje <nsnehaprabha@ti.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: [PATCH v2 0/2] Deprecate ECCGETLAYOUT
References: <4C5CA4A1.1040000@broadcom.com> <1282154806-9420-1-git-send-email-norris@broadcom.com>
In-Reply-To: <1282154806-9420-1-git-send-email-norris@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

[PATCH] mtd: Expand nand_ecc_layout, deprecate ioctl ECCGETLAYOUT

[PATCH v2 0/2] Deprecate ECCGETLAYOUT
[PATCH v2 1/2] mtd: nand: Expand nand_ecc_layout, deprecate	ioctl ECCGETLAYOUT
[PATCH v2 2/2] mtd: nand: Expand nand_ecc_layout, deprecate	ioctl ECCGETLAYOUT

[PATCH v3 1/2] mtd: Expand nand_ecc_layout, deprecate ioctl	ECCGETLAYOUT
[PATCH v3 2/2] (I can't find this in my inbox, by the way)

I'd like to see the info about what's updated in v2, v3 when revised.

By the way.

On 8/19/2010 3:06 AM, Brian Norris wrote:
> Brian Norris (2):
>   mtd: nand: Expand nand_ecc_layout, deprecate ioctl ECCGETLAYOUT
>   mtd: nand: Expand nand_ecc_layout, deprecate ioctl ECCGETLAYOUT

Two patches with the same title.  Similar symptom can be seen in your
latest v3 post (we can't find [PATCH v3 2/2]). Perhaps something weird
is in your repository (or git settings).
-- 
Shinya Kuribayashi
Renesas Electronics
