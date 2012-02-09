Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884Ab2BIIME (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 03:12:04 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:57733 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982Ab2BIIMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 03:12:02 -0500
MIME-Version: 1.0
In-Reply-To: <20120208150548.32643cmtaxtymzok@67.228.131.195>
References: <CACW_hTY41xZV6d0W2Z2kRfKOfa+RSQ-A-BoZsZwNXSQmeF_6Gg@mail.gmail.com>
	<1328729420.2261.329.camel@groeck-laptop>
	<CACW_hTbLd3kbuwJy9U2ZGDi3ypD-+KsecjYhku7jwQgFPaRqhg@mail.gmail.com>
	<20120208150548.32643cmtaxtymzok@67.228.131.195>
Date: Thu, 9 Feb 2012 09:12:01 +0100
Message-ID: <CACW_hTad_DtwR7FqqOjzvCOzbdj1PcSCEyUpg6d-G5VtDi3wbQ@mail.gmail.com>
Subject: Re: drivers/net/phy/phy.c issue
From: Frans Meulenbroeks <fransmeulenbroeks@gmail.com>
To: guenter@roeck-us.net
Cc: guenter.roeck@ericsson.com, netdev@vger.kernel.org,
        "afleming@freescale.com" <afleming@freescale.com>,
        "macro@linux-mips.org" <macro@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/2/8  <guenter@roeck-us.net>:
> Quoting "Frans Meulenbroeks" <fransmeulenbroeks@gmail.com>:
>

[...]
>> Apologies, but I cannot test on a git head kernel.
>>
>> And wrt the question of Andy in the subsequent reply.
>>
>> Hw is a Freescale MPC8313. This is a Gianfar. Is that the info you wanted?
>>
> This is the MAC. Andy was asking for the PHY chip.
>
Sorry yes.
The mac is a Marvell 88e1111bab
I suspect this to be the same as in the MPC8313RDS reference design as
this design borrows quite some stuff from it.

Frans
