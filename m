Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668Ab0HKNdB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 09:33:01 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:42063 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135Ab0HKNdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 09:33:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=eAxey9knm1luEMBe4Odte2gn5Iyg7tJJU3H4fWyx0xDCzyjPvapTF01z40PGCwjKP4
         OD+lulZjQFbLPdvA2nD1hDN5/brMx4x5DZyr5Bc0KCL/VNfl+GsaLSZmJmcd5WGIo0vZ
         Yubw+OrVQn+7cHoZALvM9RfBDQDMsmO+FvfIs=
Message-ID: <4C62A6A3.2020103@gmail.com>
Date: Wed, 11 Aug 2010 06:33:23 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Valeo de Vries <valeo@valeo.co.cc>
CC: viresh kumar <viresh.kumar@st.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Query: Patches break with Microsoft exchange server.
References: <4C5F9B25.8080401@st.com>	<AANLkTinxwRFLUibJECm0c3_oL5mYRkmscsw-xXgAHSTe@mail.gmail.com>	<4C624AE1.30504@st.com> <AANLkTi=SnPm7H75C7ycUH-GzENEDKWtncvLqeEVoEMQm@mail.gmail.com>
In-Reply-To: <AANLkTi=SnPm7H75C7ycUH-GzENEDKWtncvLqeEVoEMQm@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/2010 03:11 AM, Valeo de Vries wrote:
> On 11 August 2010 08:01, viresh kumar<viresh.kumar@st.com>  wrote:
>> On 8/11/2010 3:34 AM, Felipe Contreras wrote:
>>> On Mon, Aug 9, 2010 at 9:07 AM, viresh kumar<viresh.kumar@st.com>  wrote:
>>>>> Mail server in ST has recently changed and now we have Microsoft
>>>>> exchange server. We are using thunderbird as mail client.
>>>>> What we observed with this server is that patch are broken now while
>>>>> sending as well as receiving. Tabs are replaced by spaces and may
>>>>> be some other too which we haven't observed.
>>>>>
>>>>> Has anybody found a solution to this kind of issues? Are there any
>>>>> workarounds possible?
>>> Same in Nokia. I wrote a script to fix exchange's crap, but I also
>>> noticed some quoted-printable mails didn't get converted, so the
>>> easiest would be to tell git to always send quoted-printable.
>>>
>>
>> Hi Guys
>>
>> The situation has changed now.
>> We are informed that SP2 is already in place in ST and mail client is not
>> doing any tampering.
>>
>> When i send a mail using git send-email then it receives fine on
>> outlook but on thunderbird, tabs are converted to spaces.
>>
>> This doesn't happen with every patch on thunderbird, but only a few.
>> And observation is that it happens only with big patches.
>> (more than 500 lines)
>>
>> Any idea, how to solve issue now on thunderbird??
>
> You might be in luck:
>
>    * Choose View – Toolbars to ensure that the formatting toolbar is visible,
>    then at the left of the formatting toolbar change Body Text to Preformat.
>    (lifted straight from Google)
>
> HTH,
> Valeo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


cool... glad it's semi some what working.. doing a quick google Im 
getting directed to Documentation/email-clients.txt for thunderbird
in the above procedure.
(hope the above last post fixes your issue, and/or in email-clients.txt)

Justin P. Mattock
