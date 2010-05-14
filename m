Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758638Ab0ENIlL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 04:41:11 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51035 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757348Ab0ENIlH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 04:41:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YDR5ob4yARMx62BexEgYMeY+eU9IuZZQV76LivVf0oQWz4t+t06rU9EmOAxh50Pgiz
         uJIgX7FZlo3BKCKTt2dsuxmfX+/JM2SoHftK/xw6W8Gh/aNbThIVs6LZ3pk8ObYSAIA5
         IItcpZLlwLwTSGkyAa7+9oFm91LeakE6G7Nbc=
MIME-Version: 1.0
In-Reply-To: <AANLkTimrHGq1kZwPev7gBZu6Hqxlhe0ZscSKjEinZtcf@mail.gmail.com>
References: <AANLkTimKHkgWJJOOICzQ4TL3mbL-lvYEocwBSe3XSBVR@mail.gmail.com>
	 <AANLkTiktLXqHhop21ePIXF2kaVQbm3DIHZpLrEQOMA1e@mail.gmail.com>
	 <AANLkTimCjt0R7A23xTrmToTqTcF4ZW4sNWtjMwjVIVqe@mail.gmail.com>
	 <AANLkTinbrhuGqHss_aML3EAccOq792GUZtqzzjQqzG6I@mail.gmail.com>
	 <AANLkTimVmlPfRFu8Wo2KL1pyF6qtTSQriawvrKcsMe9Y@mail.gmail.com>
	 <AANLkTimrHGq1kZwPev7gBZu6Hqxlhe0ZscSKjEinZtcf@mail.gmail.com>
Date: Fri, 14 May 2010 12:41:02 +0400
Message-ID: <AANLkTik-gIjZu60pFWEhhe8MolQITrtk0wfpvSUCLnrD@mail.gmail.com>
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

On Friday, May 14, 2010, Jaswinder Singh Rajput
<jaswinderlinux@gmail.com> wrote:
> Hello Cyrill,
>
> On Fri, May 14, 2010 at 11:53 AM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>> On Friday, May 14, 2010, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>>>> Message from syslogd@ht at May 14 09:39:32 ...
>>>>  kernel:[  thanks Jaswinder, i'll take a look, meanwhile if you get a chance to
>>> test latest -tip/master it would be great
>>>
>>
>> it's found that we have problem in cache events, we're working on
>> that, thanks for report!
>>
>
> Great !!
>
> If you need any help from my side, please let me know. Even though it
> is very hot here, I will try my best ;-)
>
> Thanks,
> --
> Jaswinder Singh.
>

Ming is narrowing down the guilty commit. I thought about my last
patch related to escr hashing, but it shouldn't bring such effect.
Hmm...
