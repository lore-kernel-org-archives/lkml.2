Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423Ab0ENKq1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 06:46:27 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:32965 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488Ab0ENKq0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 06:46:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JoAL3BWOhEIH+Mc6fS9FZisEm2Y3pOasvuKtHhxm5qLMf8Lhw06MiGEA7TANFFtTW8
         bn009uh8DcMboBijpYVKcGUDpWzMQvmfv3vTt87jUe+d48Ous1gSUBW51PadjtQVEHZP
         rylNMxtMvgYOw7FmPJiMewkxpg9R9dCrb7Qdg=
MIME-Version: 1.0
In-Reply-To: <AANLkTinPcjUyPyUP4L7opELEbLZy-tXxkbm-nqe8Co0f@mail.gmail.com>
References: <AANLkTimKHkgWJJOOICzQ4TL3mbL-lvYEocwBSe3XSBVR@mail.gmail.com>
	 <AANLkTiktLXqHhop21ePIXF2kaVQbm3DIHZpLrEQOMA1e@mail.gmail.com>
	 <AANLkTimCjt0R7A23xTrmToTqTcF4ZW4sNWtjMwjVIVqe@mail.gmail.com>
	 <AANLkTinbrhuGqHss_aML3EAccOq792GUZtqzzjQqzG6I@mail.gmail.com>
	 <AANLkTimVmlPfRFu8Wo2KL1pyF6qtTSQriawvrKcsMe9Y@mail.gmail.com>
	 <AANLkTimrHGq1kZwPev7gBZu6Hqxlhe0ZscSKjEinZtcf@mail.gmail.com>
	 <AANLkTik-gIjZu60pFWEhhe8MolQITrtk0wfpvSUCLnrD@mail.gmail.com>
	 <AANLkTinPcjUyPyUP4L7opELEbLZy-tXxkbm-nqe8Co0f@mail.gmail.com>
Date: Fri, 14 May 2010 14:46:24 +0400
Message-ID: <AANLkTinFG0HH1ZWIVc4UoNXl_g7cv-fNP_s3rnDOuSVO@mail.gmail.com>
Subject: Re: Performance Events hangs with Intel P4 system
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 14, 2010, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> On Friday, May 14, 2010, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>> On Friday, May 14, 2010, Jaswinder Singh Rajput
>> <jaswinderlinux@gmail.com> wrote:
>>> Hello Cyrill,
>>>
>>> On Fri, May 14, 2010 at 11:53 AM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>>>> On Friday, May 14, 2010, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>>>>>> Message from syslogd@ht at May 14 09:39:32 ...
>>>>>>  kernel:[  thanks Jaswinder, i'll take a look, meanwhile if you get a chance to
>>>>> test latest -tip/master it would be great
>>>>>
>>>>
>>>> it's found that we have problem in cache events, we're working on
>>>> that, thanks for report!
>>>>
>>>
>>> Great !!
>>>
>>> If you need any help from my side, please let me know. Even though it
>>> is very hot here, I will try my best ;-)
>>>
>>> Thanks,
>>> --
>>> Jaswinder Singh.
>>>
>>
>> Ming is narrowing down the guilty commit. I thought about my last
>> patch related to escr hashing, but it shouldn't bring such effect.
>> Hmm...
>>
>
> Jaswander, if you manage to bisect it -- this would be just great.
>

ok, Ming has spotted the problem. The patch will be there soon.
