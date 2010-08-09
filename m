Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031Ab0HIJnA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 05:43:00 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54595 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755969Ab0HIJm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 05:42:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=AsCfN3MBE8Tvu6KYmHH1/d7uk/aHeOlSYgI7iWei54b2j9eqbLB2X9d95FfGys8EBe
         6gqKjN3ojQQTZ/aFYXem2zdA9bdgCvM33sQwNjQXYs1HUJwRxUTItCjmuwgAdFCrKp9c
         RO3hUzQuJGNhHkuefByYUVq5y0ooX0GCXjf3o=
Message-ID: <4C5FCDB4.1080909@gmail.com>
Date: Mon, 09 Aug 2010 02:43:16 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: viresh kumar <viresh.kumar@st.com>
CC: Matti Aarnio <matti.aarnio@zmailer.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Query: Patches break with Microsoft exchange server.
References: <4C5F9B25.8080401@st.com> <20100809064957.GB16661@pengutronix.de> <4C5FA698.90904@st.com> <20100809090137.GP13165@mea-ext.zmailer.org> <4C5FCBE1.2080303@st.com>
In-Reply-To: <4C5FCBE1.2080303@st.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2010 02:35 AM, viresh kumar wrote:
> On 8/9/2010 2:31 PM, Matti Aarnio wrote:
>> On Mon, Aug 09, 2010 at 12:26:24PM +0530, viresh kumar wrote:
>>>>
>>>> I missed this information in my last mail. We are using git send-email for
>>>> sending patches. As patches will go through Microsoft exchange server only,
>>>> so they are broken.
>>>>
>> Let your boss complain to your IT keepers.
>> "These are Machine-to-Machine messages, they must not be modified!"
>>
>>
>> It would probably be "against corporate policy" to use gmail for these emails...
>>
>
> We got one solution: Upgrade Exchange server to SP2.
> Lets see if our IT department does this upgradation.
>
> viresh.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

that or just blast them with some cryptology..i.e. pretty sure if your 
message was encapsulated(AH/ESP) they couldn't tweak it.. but then 
sending such encryption to a public list would require a _key_ on the 
other side.. wishful thinking...
(just a thought)...
:-)

Justin P. Mattock
