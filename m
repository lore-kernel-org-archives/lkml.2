Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909Ab0HWENb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 00:13:31 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:52049 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767Ab0HWENa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 00:13:30 -0400
Message-ID: <4C71F51D.2000600@renesas.com>
Date: Mon, 23 Aug 2010 13:12:13 +0900
From: Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.11) Gecko/20100711 Lightning/1.0b1 Thunderbird/3.0.6
MIME-Version: 1.0
To: Brian Norris <norris@broadcom.com>
CC: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Sneha Narnakaje <nsnehaprabha@ti.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: [PATCH v2 0/2] Deprecate ECCGETLAYOUT
References: <4C5CA4A1.1040000@broadcom.com> <1282154806-9420-1-git-send-email-norris@broadcom.com> <4C6DD170.1060807@renesas.com> <4C6E9C23.6060703@broadcom.com>
In-Reply-To: <4C6E9C23.6060703@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/21/2010 12:15 AM, Brian Norris wrote:
[ ... ]
> So this leaves the important patch set as the following two independent,
> slightly different approaches to the same problem; we should choose
> between them:
> [PATCH v3 1/2] mtd: Expand...
> [PATCH v2 2/2] mtd: nand: Expand...
> 
> Sorry if my naming, numbering, and failure of intelligence in sending
> e-mail confused anyone. I can resend with distinct names and correct
> numbering if requested.

Thanks for the explanation, got it.  I'm following that thread and
already know what's discussed and proposed, but couldn't follow the
changes made between numbered / revised patches with similar subjects.
-- 
Shinya Kuribayashi
Renesas Electronics
