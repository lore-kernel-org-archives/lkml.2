Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757Ab2GDIfw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 04:35:52 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753541Ab2GDIfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 04:35:47 -0400
Message-ID: <4FF4005E.1070106@nod.at>
Date: Wed, 04 Jul 2012 10:35:42 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120601 Thunderbird/13.0
MIME-Version: 1.0
To: Shmulik Ladkani <shmulik.ladkani@gmail.com>
CC: Artem Bityutskiy <dedekind1@gmail.com>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Richard Genoud <richard.genoud@gmail.com>
Subject: Re: [PATCH 0/5] ubi: Fix bad PEBs reserve caclulation
References: <1341389164-24409-1-git-send-email-shmulik.ladkani@gmail.com>
In-Reply-To: <1341389164-24409-1-git-send-email-shmulik.ladkani@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04.07.2012 10:05, Shmulik Ladkani wrote:
> Shmulik Ladkani (5):
>    ubi: introduce ubi->bad_peb_limit
>    ubi: Limit amount of reserved eraseblocks for bad PEB handling
>    ubi: kill CONFIG_MTD_UBI_BEB_RESERVE
>    ubi: trivial: fix comment of ubi_calculate_reserved()
>    ubi: harmonize the update of ubi->beb_rsvd_pebs

Has this patch set an impact on UBI fastmap?
...wondering why I'm CC'd. :-)

Thanks,
//richard
