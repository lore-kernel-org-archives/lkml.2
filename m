Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109Ab0HISxB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 14:53:01 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:55638 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753557Ab0HISxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 14:53:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Q1m9UPsT7yR5kGUJVaWgG3s/uLY2BBXXgOXLLKOL9eRnvU5qjLkJLpXXZRspF47N9b
         R4WID0qiwsQ9sfV1x0w4vmIO9h2lch2JWuYxm5liZKMfpcMgwkTVCSCzY0kARYT09em2
         uzNd5giS1zBj6pz4yyqtFg+rDfbYv4+KaK2WM=
Message-ID: <4C604E9D.6060500@gmail.com>
Date: Mon, 09 Aug 2010 11:53:17 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: =?UTF-8?B?TWloYWkgRG9uyJt1?= <mihai.dontu@gmail.com>
CC: viresh kumar <viresh.kumar@st.com>,
        Matti Aarnio <matti.aarnio@zmailer.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: Query: Patches break with Microsoft exchange server.
References: <4C5F9B25.8080401@st.com> <201008091735.11105.mihai.dontu@gmail.com> <4C6040FC.2020702@gmail.com> <201008092115.25992.mihai.dontu@gmail.com>
In-Reply-To: <201008092115.25992.mihai.dontu@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2010 11:15 AM, Mihai Donțu wrote:
> On Monday 09 August 2010 20:55:08 Justin P. Mattock wrote:
>> On 08/09/2010 07:35 AM, Mihai Donțu wrote:
>>> On Monday 09 August 2010 12:43:16 Justin P. Mattock wrote:
>>>> On 08/09/2010 02:35 AM, viresh kumar wrote:
>>>>> On 8/9/2010 2:31 PM, Matti Aarnio wrote:
>>>>>> On Mon, Aug 09, 2010 at 12:26:24PM +0530, viresh kumar wrote:
>>>>>>>> I missed this information in my last mail. We are using git
>>>>>>>> send-email for sending patches. As patches will go through
>>>>>>>> Microsoft exchange server only, so they are broken.
>>>>>>
>>>>>> Let your boss complain to your IT keepers.
>>>>>> "These are Machine-to-Machine messages, they must not be modified!"
>>>>>>
>>>>>>
>>>>>> It would probably be "against corporate policy" to use gmail for these
>>>>>> emails...
>>>>>
>>>>> We got one solution: Upgrade Exchange server to SP2.
>>>>> Lets see if our IT department does this upgradation.
>>>>
>>>> that or just blast them with some cryptology..i.e. pretty sure if your
>>>> message was encapsulated(AH/ESP) they couldn't tweak it.. but then
>>>> sending such encryption to a public list would require a _key_ on the
>>>> other side.. wishful thinking...
>>>> (just a thought)...
>>>
>>> Shouldn't just signing the message be enough? The server (normally) would
>>> not alter it, otherwise it will break the signature (which is a too
>>> obvious bug even for Microsoft). Or am I missing something here?
>>>
>>> PS: A local SMTP with DKIM signing capabilities could be another
>>> possibility, assuming Exchange does not break such signatures.
>>
>> yeah that would probably be just enough to get through without Microsoft
>> mucking around with the font etc.., but the biggest problem(I see) with
>> the encryption is having the key on the other end of the line.
>
> Wait. I don't think we're on the same page here. I'm talking about message
> signing (which does not require the receiving end to have any key - it's the
> same plain text e-mail with a blob after it) while you refer to actually
> encrypting the message. Mm? Or am I being extremely slow today? :-)
>

no were on the same page.. keep in mind though I'm not sure how the 
message signing thing really works, if it's just a signature verifying 
that it's from you without the other end(recipient) accepting anything, 
then the question is will microsoft still scan the email and garble it up?
Now if it's a signature where the other end needs to accept the sender 
then im guessing there's a little bit of encryption there to keep 
microsoft database scanner from doing anything(but keep in mind I never 
really setup the signature thing on e-mails so I could totally be wrong)

Justin P. Mattock

