Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751255Ab1GSNkO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 09:40:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12273 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105Ab1GSNkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 09:40:12 -0400
Message-ID: <4E25892C.8070102@redhat.com>
Date: Tue, 19 Jul 2011 09:39:56 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100505 Fedora/3.0.4-2.el6 Thunderbird/3.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 01/34] System Firmware Interface
References: <1310994528-26276-1-git-send-email-prarit@redhat.com> <1310994528-26276-2-git-send-email-prarit@redhat.com> <m2vcuz3xsz.fsf@firstfloor.org> <20110719100544.55c7f7fb@lxorguk.ukuu.org.uk> <20110719132157.GG8006@one.firstfloor.org>
In-Reply-To: <20110719132157.GG8006@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/19/2011 09:21 AM, Andi Kleen wrote:
> On Tue, Jul 19, 2011 at 10:05:44AM +0100, Alan Cox wrote:
>   
>>> Could you expand somewhat WHY you want this. What is wrong with the
>>> current code?
>>>       
>> See the previous discussions
>>     
> Ok I will put that now as description into all my code submissions @)
>
> Seriously, that REALLY belongs into a patch description.
>   

I can certainly do that on the next version.  Sorry about that Andi.

>   
>>     
>>> As for user space access on x86 "dmidecode"/libdmi works for nearly everyone,
>>> doesn't it?
>>>       
>> "on x86" (and on PC only generally)
>>
>> There are three core problems
>>
>> 1.	DMI in this sense is basically an x86 PC class device hack
>> 2.	It is obsoleted and at some point it'll vanish even on PC
>>     
> Huh? What obsoleted it? 
>
>   

The DMI specification has not been updated since January of 2003.  It
has been replaced by SMBIOS.

>> 3.	Every other platform without DMI would benefit from the
>> 	interface being generic
>>     
> Can you expand on that? The information will be always system
> specific anyways. Do you really think there's that much commonality?
>
>   

There seems to be some commonalities.  We have other arches checking for
model and vendor info.

P.

