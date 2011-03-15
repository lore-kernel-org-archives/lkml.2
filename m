Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036Ab1COJDM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 05:03:12 -0400
Received: from 1.26.mail-out.ovh.net ([46.105.43.121]:48157 "HELO
	26.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1751006Ab1COJDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 05:03:11 -0400
X-Greylist: delayed 59554 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Mar 2011 05:03:11 EDT
Message-ID: <4D7F2B4A.2000102@example.com>
Date: Tue, 15 Mar 2011 10:03:06 +0100
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110307 Icedove/3.0.11
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Where to get the network NIC's firmware? rtl_nic/rtl8105e-1.fw
References: <4D7E42A6.70409@example.com> <1300163659.8209.11.camel@marge.simson.net>
In-Reply-To: <1300163659.8209.11.camel@marge.simson.net>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 3119587168100053253
X-Ovh-Remote: 178.36.153.11 (178-36-153-11.adsl.inetia.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.03.2011 05:34, Mike Galbraith wrote:
> On Mon, 2011-03-14 at 17:30 +0100, Piotr Hosowicz wrote:
>> Hello,
>>
>> I do no have it and my Debian package doesn't have it either. I cannot
>> build and test linux-next kernels, as a minute ago. It searches for
>> rtl_nic/rtl8105e-1.fw.
>
> I would think you could just download the linux driver from the vendor,
> and pluck the firmware out.  Having spent a half hour trying to do that,
> I couldn't get there from here, so.. dunno.

I tried Realtek's website, but with no effect, they don't make the 
firmware donloadable.

Regards,

Piotr Hosowicz

-- 
Z cyklu "Uroki demokracji", czyli pytania i odpowiedzi w teledurniejach:
- Któr± postaæ ubran± tylko w przepaskê na biodrach i hu¶taj±c± siê na 
lianach gra³ Johnny Weissmuller?
- Jezusa.
NP:  -
NB: 2.6.38-rc8-git4
