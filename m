Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300Ab2JEJ6K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 05:58:10 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43434 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755217Ab2JEJ6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 05:58:08 -0400
Message-ID: <506EAF2C.7070604@monstr.eu>
Date: Fri, 05 Oct 2012 11:58:04 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: =?UTF-8?B?SmFuIEzDvGJiZQ==?= <jlu@pengutronix.de>
CC: linux-kernel@vger.kernel.org, Mike Frysinger <vapier@gentoo.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Wendy Liang <wendy.liang@petalogix.com>, linux-mtd@lists.infradead.org,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] mtd: m25p80: Add support for Numonyx N25Q128
References: <1349372416-16925-1-git-send-email-monstr@monstr.eu> <1349423405.3427.3.camel@coredoba.hi.pengutronix.de>
In-Reply-To: <1349423405.3427.3.camel@coredoba.hi.pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/2012 09:50 AM, Jan Lübbe wrote:
> On Thu, 2012-10-04 at 19:40 +0200, Michal Simek wrote:
>> From: Wendy Liang <wendy.liang@petalogix.com>
>>
>> Add the id and sector mappings for SPI flash chips.
>
> An equivalent patch is already in David Woodhouse's l2-mtd tree:
> http://git.infradead.org/users/dedekind/l2-mtd.git/commitdiff/3105875f6b8902628caee2fd7821af43707c6bde

Great thanks.
Michal


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
