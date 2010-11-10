Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757226Ab0KJRMX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 12:12:23 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44181 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757193Ab0KJRMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 12:12:22 -0500
Message-ID: <4CDAD255.3050309@zytor.com>
Date: Wed, 10 Nov 2010 09:11:49 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Thunderbird/3.1.6
MIME-Version: 1.0
To: Baruch Siach <baruch@tkos.co.il>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Alex Gershgorin <agersh@rambler.ru>
Subject: Re: [PATCH] drivers/misc: Altera Cyclone active serial implementation
References: <879a6320efee16c04f0732a6887b95c1b4c6d10f.1288793522.git.baruch@tkos.co.il>
In-Reply-To: <879a6320efee16c04f0732a6887b95c1b4c6d10f.1288793522.git.baruch@tkos.co.il>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/2010 07:21 AM, Baruch Siach wrote:
> From: Alex Gershgorin <agersh@rambler.ru>
> 
> The active serial protocol can be used to program Altera Cyclone FPGA devices.
> This driver uses the kernel gpio interface to implement the active serial
> protocol.
> 

Calling it "Cyclone" is a bit misleading.  This protocol is used by
Stratix, Cyclone and Arria devices (at least), and it probably depends
more on the generation than on the product line which exact version of
the protocol it is.

If anything it would probably be more accurate to call it a Statix
protocol, or just an Altera one.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

