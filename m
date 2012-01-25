Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755731Ab2AYNwq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 08:52:46 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49536 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755042Ab2AYNwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 08:52:45 -0500
Message-ID: <4F2016F4.2080302@mvista.com>
Date: Wed, 25 Jan 2012 17:51:32 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: "Manjunathappa, Prakash" <prakash.pm@ti.com>
CC: linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com,
        Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH v2 3/3] arm: da830: move NAND and NOR devices as aemif
 MFD slaves
References: <1327487156-10238-1-git-send-email-prakash.pm@ti.com> <1327487156-10238-3-git-send-email-prakash.pm@ti.com>
In-Reply-To: <1327487156-10238-3-git-send-email-prakash.pm@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 01/25/2012 01:25 PM, Manjunathappa, Prakash wrote:

> NAND and NOR device are made as aemif devices slave, hence device
> registration achieved via aemif MFD driver.

> Signed-off-by: Manjunathappa, Prakash<prakash.pm@ti.com>
> ---
> Since v1:
> Patch is generated using -M option.

>   arch/arm/mach-davinci/board-da830-evm.c |   31 +++++++++++++++++++++++--------
>   1 files changed, 23 insertions(+), 8 deletions(-)

    Why only this file? Don't other board files have NAND/NOR devices?

WBR, Sergei
