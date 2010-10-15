Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932390Ab0JOTY4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 15:24:56 -0400
Received: from 63.mail-out.ovh.net ([91.121.185.56]:50270 "HELO
	63.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932352Ab0JOTYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 15:24:55 -0400
Message-ID: <4CB8AA76.2020309@eukrea.com>
Date: Fri, 15 Oct 2010 21:24:38 +0200
From: =?ISO-8859-1?Q?Eric_B=E9nard?= <eric@eukrea.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-usb@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        s.hauer@pengutronix.de, Dinh.Nguyen@freescale.com, leoli@freescale.com,
        dbrownell@users.sourceforge.net, gregkh@suse.de,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mxc_udc: add workaround for ENGcm09152 for i.MX35
References: <1287145858-10239-1-git-send-email-eric@eukrea.com> <20101015191005.GB8098@kroah.com>
In-Reply-To: <20101015191005.GB8098@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 12283286508930248168
X-Ovh-Remote: 82.233.81.124 (tal33-3-82-233-81-124.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Le 15/10/2010 21:10, Greg KH a écrit :
> On Fri, Oct 15, 2010 at 02:30:58PM +0200, Eric Bénard wrote:
>> this patch gives the possibility to workaround bug ENGcm09152
>> on i.MX35 when the hardware workaround is also implemented on
>> the board.
>> It covers the workaround described on page 25 of the following Errata :
>> http://cache.freescale.com/files/dsp/doc/errata/IMX35CE.pdf
>>
>> Signed-off-by: Eric Bénard<eric@eukrea.com>
>> ---
>>   arch/arm/mach-mx3/mach-cpuimx35.c |    1 +
>>   drivers/usb/gadget/fsl_mxc_udc.c  |   15 +++++++++++++++
>>   include/linux/fsl_devices.h       |    3 +++
>>   3 files changed, 19 insertions(+), 0 deletions(-)
>
> Do you want me to take this through my usb tree, or will it go through
> some other developer's tree?
>
as most of the changes are in drivers/usb that would be great if you can take it.

Thanks
Eric
