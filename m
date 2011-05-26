Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758523Ab1EZUcg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 16:32:36 -0400
Received: from smtp103.prem.mail.sp1.yahoo.com ([98.136.44.58]:30892 "HELO
	smtp103.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758499Ab1EZUcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 16:32:33 -0400
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: gBkeNNsVM1lVGx4pWB3y_qKI7XuwySxMF4Q92dVSkXg85R4
 r.T45loeHUjAyh8KjyrGDfor3xR3ZGFn6gnawJLOkbWePcKh43Hfi0.WnEgM
 GFVohNhHdFLWifaIWr4sixX5mYYBY0A1hzL0emD5_EJzkm.k2pj6fCJgvt4u
 Uno.9GD0mr6.q3TqGmSeDGcK5yPdnFcZvuzDbHI_qb.XqN0F3TA1wG4hFHhR
 elc9DgaZhchRqyTT42V4suCulzLOs5jWQ1opSwRpTFgUFNiw069NQvY2Ii74
 MBG8HA.V1HwKKad0rwm6d.k2saZV8LPZs1O0MhjgbNZm3a9tPfQBvtKtYX56
 bQGOQNLHdKUes9WrX9DtRSh0QkntRh60lEg--
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4DDEB8DC.5070908@schaufler-ca.com>
Date: Thu, 26 May 2011 13:32:28 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: David Safford <safford@watson.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, James Morris <jmorris@namei.org>,
        Greg KH <greg@kroah.com>, Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: Re: [PATCH v5 00/21] EVM
References: <1305557115-15652-1-git-send-email-zohar@linux.vnet.ibm.com> <20110518172552.6d482c7a.akpm@linux-foundation.org> <20110526060842.GA13933@localhost.ucw.cz> <4DDE80FE.7010005@schaufler-ca.com> <1306433514.24986.26.camel@localhost.localdomain> <20110526183849.GA4563@ucw.cz> <4DDEAA3F.3030008@schaufler-ca.com> <20110526200207.GB15959@elf.ucw.cz>
In-Reply-To: <20110526200207.GB15959@elf.ucw.cz>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/26/2011 1:02 PM, Pavel Machek wrote:
> On Thu 2011-05-26 12:30:07, Casey Schaufler wrote:
>> On 5/26/2011 11:38 AM, Pavel Machek wrote:
>>> On Thu 2011-05-26 14:11:54, David Safford wrote:
>>>> On Thu, 2011-05-26 at 09:34 -0700, Casey Schaufler wrote:
>>>>> On 5/25/2011 11:08 PM, Pavel Machek wrote:
>>>>>> ...
>>>>>> Fourthly, is it likely to find its way to the next cellphone I buy,
>>>>>> and will it prevent me from rooting it?
>>>>> That will of course depend on the phone vendor. You are certainly
>>>>> going to be able to vote with your checkbook (digital wallet?) but
>>>>> odds are pretty good that should EVM prove effective it will be
>>>>> ubiquitous within the next five years on embedded devices.
>>> Hmm. But maybe it is more effective to vote with NAKs, now? It does
>>> not seem to have any non-evil uses.
>>>
>>> Phone vendors will play nasty tricks on us, but... why make it easy
>>> for them?
>> For one thing, it is probable that in the not-too-distant future
>> the phone will not be yours. Many service providers are moving in
>> the direction of zero-cost phones. The subscriber will pay the
> Really? References?

Yes, and no.

> No, I don't think this is going to happen, for variety of reasons. 1)
> prepaid cards, 2) phones are easily damaged, 3) phones are often stolen.

I have no idea how prepaid cards make a difference, but I'm willing
to be educated.

Phones are commodity electronics. If they get damaged they get replaced.
That's another selling point for the scheme. Clumsy customers will love
it.

"Someone stole my SSRBQ phone!"
"Thank you sir, we'll track down our phone using the GPS software we
 put on it. Now we'll use the battery overload software we just downloaded
 to it to heat it up and set the magnesium case on fire. What's that sir?
 your dog just exploded?"

Seriously, the service provider will download meltdown software to
the stolen phone and treat it as broken. The customer gets a new phone
to use. No worries.

>> Most people will not notice the difference. Consider this a
>> nasty trick if you want to. I expect that the average consumer
> I _do_ consider it nasty trick...

It's only "nasty" if the customer doesn't like it.
It's only a trick if the fact that the customer does not own the phone
is hidden. I fully expect the providers to tout it as a feature.

>> Welcome to computers in the 21st century.
> ...and I do not want to help people playing nasty tricks. Protection
> against offline attacks should not be merged.
>
> 								Pavel

OK, but what about the owners of loaned phones, set top boxes or aircraft
entertainment systems, who routinely put their hardware in the hands of
people they have no reason to trust? I suppose they can run WinCE. Or
Symbian.

