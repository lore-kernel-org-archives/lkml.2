Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758941Ab0ENKFA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 06:05:00 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:34791 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802Ab0ENKE7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 06:04:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YJMMDNgAhQf4YriQpWpHvSVVmOQWKVNNhkm7AFsLvrsvqKTT4gpwtySFPD4tTronXW
         mzWMJZkgeR87c+GbJuHZHy2d5n78Em1lfdjzP2Cx6ISdYhrpMhFO/54mWqhJdCkB0daH
         5Hg31Z2VUpl3AYl0nMVcJZayaaU8IErW3QNjM=
MIME-Version: 1.0
In-Reply-To: <AANLkTik-gIjZu60pFWEhhe8MolQITrtk0wfpvSUCLnrD@mail.gmail.com>
References: <AANLkTimKHkgWJJOOICzQ4TL3mbL-lvYEocwBSe3XSBVR@mail.gmail.com>
	 <AANLkTiktLXqHhop21ePIXF2kaVQbm3DIHZpLrEQOMA1e@mail.gmail.com>
	 <AANLkTimCjt0R7A23xTrmToTqTcF4ZW4sNWtjMwjVIVqe@mail.gmail.com>
	 <AANLkTinbrhuGqHss_aML3EAccOq792GUZtqzzjQqzG6I@mail.gmail.com>
	 <AANLkTimVmlPfRFu8Wo2KL1pyF6qtTSQriawvrKcsMe9Y@mail.gmail.com>
	 <AANLkTimrHGq1kZwPev7gBZu6Hqxlhe0ZscSKjEinZtcf@mail.gmail.com>
	 <AANLkTik-gIjZu60pFWEhhe8MolQITrtk0wfpvSUCLnrD@mail.gmail.com>
Date: Fri, 14 May 2010 14:04:56 +0400
Message-ID: <AANLkTinPcjUyPyUP4L7opELEbLZy-tXxkbm-nqe8Co0f@mail.gmail.com>
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
> On Friday, May 14, 2010, Jaswinder Singh Rajput
> <jaswinderlinux@gmail.com> wrote:
>> Hello Cyrill,
>>
>> On Fri, May 14, 2010 at 11:53 AM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>>> On Friday, May 14, 2010, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>>>>> Message from syslogd@ht at May 14 09:39:32 ...
>>>>>  kernel:[  thanks Jaswinder, i'll take a look, meanwhile if you get a chance to
>>>> test latest -tip/master it would be great
>>>>
>>>
>>> it's found that we have problem in cache events, we're working on
>>> that, thanks for report!
>>>
>>
>> Great !!
>>
>> If you need any help from my side, please let me know. Even though it
>> is very hot here, I will try my best ;-)
>>
>> Thanks,
>> --
>> Jaswinder Singh.
>>
>
> Ming is narrowing down the guilty commit. I thought about my last
> patch related to escr hashing, but it shouldn't bring such effect.
> Hmm...
>

Jaswander, if you manage to bisect it -- this would be just great.
