Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946Ab2KGMti (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 07:49:38 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:54962 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242Ab2KGMth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 07:49:37 -0500
MIME-Version: 1.0
In-Reply-To: <20121105215410.GC1254@beefymiracle.amer.corp.natinst.com>
References: <1352151949-18319-1-git-send-email-nbowler@elliptictech.com>
	<20121105215410.GC1254@beefymiracle.amer.corp.natinst.com>
Date: Wed, 7 Nov 2012 13:49:36 +0100
X-Google-Sender-Auth: PxbnT8vwlDLXktWk71xEvVu2pA8
Message-ID: <CAHTX3dKV470iByg8MybxSch4i+r7_VxOWtxmeS94JapL4YpRYA@mail.gmail.com>
Subject: Re: [PATCH v3] ARM: zynq: Allow UART1 to be used as DEBUG_LL console.
From: Michal Simek <michal.simek@xilinx.com>
To: Josh Cartwright <josh.cartwright@ni.com>
Cc: Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        Arnd Bergmann <arnd@arndb.de>, John Linn <john.linn@xilinx.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/11/5 Josh Cartwright <josh.cartwright@ni.com>:
> On Mon, Nov 05, 2012 at 04:45:49PM -0500, Nick Bowler wrote:
>> The main UART on the Xilinx ZC702 board is UART1, located at address
>> e0001000.  Add a Kconfig option to select this device as the low-level
>> debugging port.  This allows the really early boot printouts to reach
>> the USB serial adaptor on this board.
>>
>> For consistency's sake, add a choice entry for UART0 even though it is
>> the the default if UART1 is not selected.
>>
>> Signed-off-by: Nick Bowler <nbowler@elliptictech.com>
>> Tested-by: Josh Cartwright <josh.cartwright@ni.com>
>> ---
>> Sorry all for the phenominal delay in sending this out.  Josh, I kept
>> your Tested-By since this version is Obviously Equivalent??? to v2...
>
> I re-tested again just in case and everything is good.


Thanks guys, Applied.

Michal
