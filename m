Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229Ab0ENCMk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 22:12:40 -0400
Received: from 29.mail-out.ovh.net ([87.98.216.213]:42385 "HELO
	29.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751250Ab0ENCMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 22:12:34 -0400
Message-ID: <4BECB18C.5050005@example.com>
Date: Fri, 14 May 2010 04:12:28 +0200
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100411 Icedove/3.0.4
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: General questiin about SYSFS
References: <4BEC4B0D.8010102@example.com> <20100513200718.GA18479@kroah.com>
In-Reply-To: <20100513200718.GA18479@kroah.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 12794163593349394920
X-Ovh-Remote: 83.24.77.38 (dmv38.neoplus.adsl.tpnet.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.05.2010 22:07, Greg KH wrote:
> On Thu, May 13, 2010 at 08:55:09PM +0200, Piotr Hosowicz wrote:
>> Hello,
>>
>> I have a simple question = I've heard rumours here and there that
>> SYSFS is deprecated and forthcoming kernels won't use it
>
> Nope, not true at all.  Where did you hear those rumors so that I can go
> after them with a big stick and squash them?

Sorry, these must have been some random rumours in my head which came to 
being during wild Debian upgrades sessions I had.

>> I even see some warning during boot.
>
> What specific warning are you seeing?

See my parallel email. I didn't understand them, this - as it appeared - 
is udev question.

>> Is it true? And where to disable it in the config?
>
> If you want to disable sysfs, you can, it's in the config file, but you
> have to really know what you are doing otherwise you will usually end up
> with a system that does not boot properly.

Now I see, thanks for the reply.

Regards,

Piotr Hosowicz

-- 
Janusz Korwin-Mikke:
"Idiota z dyplomem to taki sam idiota,
jak przedtem - tylko z pretensjami."
NP: Patrick O'Hearn - Night Becomes Her
NB: 2.6.34-rc7-git4
