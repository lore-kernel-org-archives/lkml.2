Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932210Ab0ENHwX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 03:52:23 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33880 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757352Ab0ENHwW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 03:52:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uePSxg2nscBbUuSxft/jbJIn/MYLr/7OoMma3gHyAp6SP3CIkKLqoodN3tecOOiUdh
         gIdFlciLS1IuhTUSy1IZBYCAq2vPN6H3z85E5S0eQWw14DYirdq37XTulqum77W79FOl
         YyeYw1c2MX0+8l0ObM85dntgI8jw6iUH46OZQ=
MIME-Version: 1.0
In-Reply-To: <AANLkTimVmlPfRFu8Wo2KL1pyF6qtTSQriawvrKcsMe9Y@mail.gmail.com>
References: <AANLkTimKHkgWJJOOICzQ4TL3mbL-lvYEocwBSe3XSBVR@mail.gmail.com>
	 <AANLkTiktLXqHhop21ePIXF2kaVQbm3DIHZpLrEQOMA1e@mail.gmail.com>
	 <AANLkTimCjt0R7A23xTrmToTqTcF4ZW4sNWtjMwjVIVqe@mail.gmail.com>
	 <AANLkTinbrhuGqHss_aML3EAccOq792GUZtqzzjQqzG6I@mail.gmail.com>
	 <AANLkTimVmlPfRFu8Wo2KL1pyF6qtTSQriawvrKcsMe9Y@mail.gmail.com>
Date: Fri, 14 May 2010 13:22:12 +0530
Message-ID: <AANLkTimrHGq1kZwPev7gBZu6Hqxlhe0ZscSKjEinZtcf@mail.gmail.com>
Subject: Re: Performance Events hangs with Intel P4 system
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Cyrill,

On Fri, May 14, 2010 at 11:53 AM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> On Friday, May 14, 2010, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>>> Message from syslogd@ht at May 14 09:39:32 ...
>>>  kernel:[  thanks Jaswinder, i'll take a look, meanwhile if you get a chance to
>> test latest -tip/master it would be great
>>
>
> it's found that we have problem in cache events, we're working on
> that, thanks for report!
>

Great !!

If you need any help from my side, please let me know. Even though it
is very hot here, I will try my best ;-)

Thanks,
--
Jaswinder Singh.
