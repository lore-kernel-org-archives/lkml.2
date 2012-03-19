Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031904Ab2CSR23 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 13:28:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55129 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932434Ab2CSR21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 13:28:27 -0400
Message-ID: <4F676C94.4010606@redhat.com>
Date: Mon, 19 Mar 2012 14:27:48 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: "Justin P. Mattock" <justinmattock@gmail.com>
CC: Greg KH <gregkh@linuxfoundation.org>, Jiri Kosina <jkosina@suse.cz>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        marauder@tiscali.it, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH V2]NEXT:drivers:staging:media Fix comments and some typos
 in staging/media/*
References: <1331045709-19309-1-git-send-email-justinmattock@gmail.com> <4F635DBF.7000603@gmail.com> <alpine.LNX.2.00.1203161644190.18356@pobox.suse.cz> <20120316155845.GA975@kroah.com> <4F636514.1080303@gmail.com> <4F636570.7090706@gmail.com>
In-Reply-To: <4F636570.7090706@gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 16-03-2012 13:08, Justin P. Mattock escreveu:
> On 03/16/2012 09:06 AM, Justin P. Mattock wrote:
>> On 03/16/2012 08:58 AM, Greg KH wrote:
>>> On Fri, Mar 16, 2012 at 04:45:03PM +0100, Jiri Kosina wrote:
>>>> On Fri, 16 Mar 2012, Justin P. Mattock wrote:
>>>>
>>>>> before I forget about this patch, what was the status of this one?
>>>>
>>>> As previously announced multiple times, I am ignoring patches that go to
>>>> drivers/staging and letting Greg pick them up if he wants to.
>>>>
>>>> Greg, if you want to have this changed, just let me know.
>>>
>>> No, no objection from me, but patches to drivers/staging/media/ do not
>>> go through me, please see the MAINTAINERS file for the owner of those
>>> (hint, it's Mauro...)
>>>
>>> thanks,
>>>
>>> greg k-h
>>>
>>
>> ahh!! I got it now.. your in charge of the staging tree but for each
>> branch there is an owner(I thought to just send to greg KH and thats it)
>>
>> adding Mauro to the Cc's so he can view the patch, then on any other
>> patch I send to staging I will send it to the maintainer then the rest
>> as follows with a cc's.
>>
>> Thanks for the help on this.
>>
>> Justin P. Mattock
> 
> and of course pressed send without the Maintainer on it.. duh!

I'm applying it on my tree. Thanks!
Mauro

> 
> Justin P. Mattock
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

