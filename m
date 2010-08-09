Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577Ab0HIHcL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 03:32:11 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:45918 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497Ab0HIHcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 03:32:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=aZ1HAAcm5APWJ0JAdkAjHAiMaV8N6xaOH9oNCYuP5j89nOfGvJRIPlGHTxvF8FGnAk
         75451Q4vKZBB2D3gzF18jlNzesehOOIjn2Br7YsAUO5KOpWeuXXbVaB3VxWfcd3Yteur
         PX7uar9aPc0R9V6LmxixhBZUaPsbW3OZDNb94=
Message-ID: <4C5FAF04.9070705@gmail.com>
Date: Mon, 09 Aug 2010 00:32:20 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: viresh kumar <viresh.kumar@st.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Query: Patches break with Microsoft exchange server.
References: <4C5F9B25.8080401@st.com> <4C5FA35E.50309@gmail.com> <4C5FA66D.7060404@st.com>
In-Reply-To: <4C5FA66D.7060404@st.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2010 11:55 PM, viresh kumar wrote:
> On 8/9/2010 12:12 PM, Justin P. Mattock wrote:
>> On 08/08/2010 11:07 PM, viresh kumar wrote:
>>>> Hello,
>>>>
>>>> Mail server in ST has recently changed and now we have Microsoft
>>>> exchange server. We are using thunderbird as mail client.
>>>> What we observed with this server is that patch are broken now while
>>>> sending as well as receiving. Tabs are replaced by spaces and may
>>>> be some other too which we haven't observed.
>>>>
>>>> Has anybody found a solution to this kind of issues? Are there any
>>>> workarounds possible?
>>>>
>>
>> still trying to figure this out with thunderbird.. but did notice in
>> Documentation/email-clients.txt and SubmittingPatches
>> there's info about that(just haven't gotten around to reading use git
>> send-email for patches)
>>
>> hope this helps.
>
> I missed this information in my last mail. We are using git send-email for
> sending patches. As patches will go through Microsoft exchange server only,
> so they are broken.
>
> viresh.
>


hmm.. then I don't know the answer to that.. always send through git 
send-email(patches)and things are good(knock-on-wood)always ran into 
issues with copy/pasting onto thunderbird. Hopefully somebody else with 
more knowledge of using git send-email patches through microsoft 
exchange answers this..

side note: maybe postfix or some type of wrapper around the wording 
message(utf-8) to keep microsoft from mangling things or 
something.(tough to say though)

Justin P. Mattock
