Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833Ab2LRTwf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 14:52:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14153 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753932Ab2LRTwe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 14:52:34 -0500
Message-ID: <50D0BD39.8030208@redhat.com>
Date: Tue, 18 Dec 2012 17:00:09 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Borislav Petkov <bp@alien8.de>, Jacob Shin <jacob.shin@amd.com>,
        Doug Thompson <dougthompson@xmission.com>, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] MCE, AMD: MCE decoding support for AMD Family 16h
References: <1355773188-5241-1-git-send-email-jacob.shin@amd.com>  <1355773188-5241-2-git-send-email-jacob.shin@amd.com>  <20121218171915.GE31255@liondog.tnic> <1355855069.30366.14.camel@joe-AO722>  <20121218183330.GH31255@liondog.tnic> <1355855866.30366.21.camel@joe-AO722>
In-Reply-To: <1355855866.30366.21.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 18-12-2012 16:37, Joe Perches escreveu:
> On Tue, 2012-12-18 at 19:33 +0100, Borislav Petkov wrote:
>> On Tue, Dec 18, 2012 at 10:24:29AM -0800, Joe Perches wrote:
>>> or without all the unnecessary parens and using char:
>>>
>>> 			pr_cont("%cBUFF parity error\n", xec == 4 ? 'I' : 'O');
>>
>> Char is fine, the parens make this more readable when you look at it
>> again after a couple of months :-).
>
> <shrug>
>
> I think the unnecessary parens make it _less_ readable
> because you need to parse more stuff and it's easy to
> misplace those parens.

I agree with Boris: the parenthesis at the test (xec == 4) makes it
easier to read, IMO.

Regards,
Mauro
