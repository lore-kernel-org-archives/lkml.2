Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798Ab1C1O62 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 10:58:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54460 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753543Ab1C1O60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 10:58:26 -0400
Message-ID: <4D90A1FE.4000405@zytor.com>
Date: Mon, 28 Mar 2011 07:58:06 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: richard -rw- weinberger <richard.weinberger@gmail.com>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com,
        torvalds@linux-foundation.org, rostedt@goodmis.org,
        srostedt@redhat.com, tglx@linutronix.de, adobriyan@gmail.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/urgent] WARN_ON_SMP(): Add comment to explain ({0;})
References: <tip-ccd0d44fad38dc1bb4b26dcc7a30e9f2c3b36870@git.kernel.org>	<4D90A08D.707@zytor.com> <AANLkTinh6nraZND1mQJ4ofPbABOtJNEnGYYEkqs92RQM@mail.gmail.com>
In-Reply-To: <AANLkTinh6nraZND1mQJ4ofPbABOtJNEnGYYEkqs92RQM@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/2011 07:56 AM, richard -rw- weinberger wrote:
>>
>> What the heck is wrong with the idiomatic and non-gcc-extension-using:
>>
>>        ((void)0)
>>
>> ?
> 
> AFAIK you cannot use it within an if-statement.
> 

OK, fair enough.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

