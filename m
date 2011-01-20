Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910Ab1ATIIh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 03:08:37 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50709 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754162Ab1ATIIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 03:08:36 -0500
Message-ID: <4D37ED80.6000205@monstr.eu>
Date: Thu, 20 Jan 2011 09:08:32 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Peter Korsgaard <jacmet@sunsite.dk>
CC: linux-serial@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Uartlite - ulite_transmit
References: <4D2465E0.2000707@monstr.eu> <4D246672.3070002@monstr.eu>	<87vd22h3dq.fsf@macbook.be.48ers.dk> <4D257D61.2060400@monstr.eu>	<87r5cqh0bn.fsf@macbook.be.48ers.dk> <4D25871D.2000408@monstr.eu>	<87mxnegy4u.fsf@macbook.be.48ers.dk> <4D26C538.3010101@monstr.eu>	<4D26D79C.8060304@monstr.eu> <4D2D78F3.2040903@monstr.eu>	<87aaj6zays.fsf@macbook.be.48ers.dk> <4D2D8113.1020504@monstr.eu>	<8739oyza2n.fsf@macbook.be.48ers.dk> <4D32B5A2.1070508@monstr.eu>	<87r5cc5zqp.fsf@macbook.be.48ers.dk> <4D345DA3.8020105@monstr.eu>	<87oc7cgbi1.fsf@macbook.be.48ers.dk> <4D37EC89.2080802@monstr.eu> <87d3nsdmn4.fsf@macbook.be.48ers.dk>
In-Reply-To: <87d3nsdmn4.fsf@macbook.be.48ers.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Korsgaard wrote:
>>>>>> "Michal" == Michal Simek <monstr@monstr.eu> writes:
> 
> Hi,
> 
>  >> /* flush input and output queues, important for modems! */
>  >> tcflush(0, TCIOFLUSH);
>  >> 
>  >> You could change that to a tcdrain() if that's not what you want.
>  >> 
> 
>  Michal> Great that's work. Just for the record it is tcdrain(STDOUT_FILENO);
> 
> Yes. Notice that the code has changed a bit in busybox git (but same
> functionality).
> 
>  Michal> Patch against busybox 1.14.3 version is below. Maybe worth to
>  Michal> added it mainline busybox.
> 
> Yes, please bring it up with the busybox devs.
> 
>  Michal> Thanks for your big help.
> 
> You're welcome.

Will do in a sec. I will CC you too.

Thanks,
Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
