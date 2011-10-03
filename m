Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932576Ab1JCUu3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 16:50:29 -0400
Received: from smtp.tele.fi ([192.89.123.25]:34149 "EHLO
	vulpes-int.media.sonera.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755033Ab1JCUuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 16:50:21 -0400
X-Greylist: delayed 2223 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Oct 2011 16:50:21 EDT
X-Originating-Ip: [194.89.68.22]
Date: Mon, 3 Oct 2011 23:13:16 +0300
From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: HighPoint RocketRaid 620 vs. RocketRaid 640 -- supported?
Message-ID: <20111003201315.GD12984@reaktio.net>
References: <alpine.DEB.2.02.1109191754531.7938@p34.internal.lan> <alpine.DEB.2.02.1109210726250.31360@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1109210726250.31360@p34.internal.lan>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 07:28:26AM -0400, Justin Piszcz wrote:
> Hi,
>
> Incase anyone is wondering the same thing, I contacted Highpoint and they 
> said (confirmed) the 620 support (which I am using now) is built-in to 
> the kernel and the 640 is not, so unless you like compiling kernel 
> modules/out of tree drivers for a _boot_ volume and want a regular SATA 
> 6.0gbps controller that supports TRIM, I'd go for the 620 even though it 
> maxes out around 390-420MiB/s read where a real SAS controller supports 
> 490-500MiB/s for an Intel 510 SSD, but remember, SAS controllers (at 
> least the one I tested with does not support TRIM and there is no Intel 
> SSD optimizer for Linux.
>

Hmm.. does SAS "SCSI UNMAP" automatically get translated to 
ATA TRIM if you hook up SATA disk to SAS HBA ?

Is the ATA<->SCSI translation being done by the HBA firmware, 
or is it handled in the driver? 

-- Pasi (who is too lazy to grep in the driver right now ;)


> Justin.
>
> On Mon, 19 Sep 2011, Justin Piszcz wrote:
>
>> Hi,
>>
>> I have a HighPoint RocketRaid 620 and it works fine with 3.0+.
>> The HighPoint RocketRaid 640 also has a Marvell 88SE9128, can anyne 
>> confirm whether this (x4) PCI-e 2.0 card works in Linux with the 
>> built-in kernel driver?
>>
>> Justin.
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
