Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005Ab2KFNOy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 08:14:54 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:55905 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab2KFNOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 08:14:53 -0500
Message-ID: <50990D46.2050900@ahsoftware.de>
Date: Tue, 06 Nov 2012 14:14:46 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org
Subject: Re: AMD A10: MCE Instruction Cache Error
References: <5093A592.9070605@ahsoftware.de> <5093D069.20901@ahsoftware.de> <20121103044929.GB21829@liondog.tnic> <5094F5C5.1000000@ahsoftware.de> <20121104152133.GA16116@x1.osrc.amd.com> <5096A3A4.8070602@ahsoftware.de> <20121106091057.GC2090@x1.osrc.amd.com> <5098F1F5.5060709@ahsoftware.de> <5098F816.5040206@ahsoftware.de>
In-Reply-To: <5098F816.5040206@ahsoftware.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 06.11.2012 12:44, schrieb Alexander Holler:
> Am 06.11.2012 12:18, schrieb Alexander Holler:
>> I will now to tests with leaving fglrx off.
>
> s/to/do/ ;)
>
> That was gone fast. Disabled fglrx, started tests, full halt without any
> visible on the serial (I needed to press the reset button):

One after another, now I've got this:

[ 5698.640830] [Hardware Error]: CPU:0 
MC2_STATUS[Over|CE|MiscV|-|AddrV|-|-|CECC]: 0xdc2540c000040136
[ 5698.649866] [Hardware Error]:        MC2_ADDR: 0x0000000002299678
[ 5698.655443] [Hardware Error]: Combined Unit Error: Fill ECC error on 
data fills.
[ 5698.662849] [Hardware Error]: cache level: L2, tx: DATA, mem-tx: DRD

I think it's now really an RMA and I can stop doing further tests.

Regards,

Alexander

