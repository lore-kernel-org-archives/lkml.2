Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686Ab2DBTOs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 15:14:48 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43976 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258Ab2DBTOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 15:14:47 -0400
Message-ID: <4F79FAA6.8060900@samsung.com>
Date: Mon, 02 Apr 2012 12:14:46 -0700
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Nicolas Pitre <nico@fluxnic.net>
CC: Kukjin Kim <kgene.kim@samsung.com>, linux-kernel@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        viro@zeniv.linux.org.uk
Subject: Re: error: 'SEGMENT_SIZE' undeclared with arm-eabi-gcc toolchain
References: <4F7638C3.4060301@samsung.com> <alpine.LFD.2.02.1203310017440.24151@xanadu.home>
In-Reply-To: <alpine.LFD.2.02.1203310017440.24151@xanadu.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Pitre wrote:
> On Fri, 30 Mar 2012, Kukjin Kim wrote:
>

[...]

Hi Nicolas,

> So the clue you're looking for is probably on the 18th line above.
>
Ah Yep, I see.

> BTW, no one is using a.out on ARM anymore.  You should really consider
> removing CONFIG_BINFMT_AOUT from your config.
>
Oh, now s3c2410_defconfig has it. OK, let me fix it.

Thank you for your time and kindly explanation.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.
