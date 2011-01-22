Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556Ab1AVLS4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 06:18:56 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:64819 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820Ab1AVLSz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 06:18:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Rig+wEXmJcmKt68P+8+HbIj7I3k+JET4g3kyNqNiQITuD+V05I99jghlEupMYdYCeg
         iQ3qj0V+4yHkVa/O0fEP2E9hzDuCttXgIvO0lBeE/Cz4Et7/Clb+OBfFto5TfgOEYaXN
         JqOew9tmjVYSs5M+uS/TPU6aFET+dCtUeRClk=
MIME-Version: 1.0
In-Reply-To: <1295645098.22882.1.camel@m0nster>
References: <1295555565-21563-1-git-send-email-dwalker@codeaurora.org>
	<AANLkTik+HCj9dkD2s4WgwCqKWCXDbdSnKDUbyGfYfaPr@mail.gmail.com>
	<1295571359.9236.53.camel@m0nster>
	<1295574085.4096.6.camel@Joe-Laptop>
	<1295575123.9236.54.camel@m0nster>
	<1295576730.4096.24.camel@Joe-Laptop>
	<1295624801.19880.13.camel@m0nster>
	<20110121094827.41818a55@jbarnes-desktop>
	<20110121095658.1ab623fe@jbarnes-desktop>
	<1295632828.19880.22.camel@m0nster>
	<20110121100441.06a94482@jbarnes-desktop>
	<1295633882.19880.31.camel@m0nster>
	<AANLkTi=L+MW5-KLP_TKSxhstD8JEtBW=RKci5wSbZsd6@mail.gmail.com>
	<1295642995.19880.42.camel@m0nster>
	<1295643762.25868.31.camel@Joe-Laptop>
	<1295645098.22882.1.camel@m0nster>
Date: Sat, 22 Jan 2011 13:18:54 +0200
X-Google-Sender-Auth: qxMJaG-NLodHDTzk-JscVSL-VeU
Message-ID: <AANLkTi=mvdfpCPefGeDr+eGxpSUr3is5jgugHtgB-m1w@mail.gmail.com>
Subject: Re: [PATCH 0/7] Nexus One Support
From: Pekka Enberg <penberg@kernel.org>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: Joe Perches <joe@perches.com>, Dima Zavin <dmitriyz@google.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        davidb@codeaurora.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On Fri, Jan 21, 2011 at 11:24 PM, Daniel Walker <dwalker@codeaurora.org> wrote:
> On Fri, 2011-01-21 at 13:02 -0800, Joe Perches wrote:
>> On Fri, 2011-01-21 at 12:49 -0800, Daniel Walker wrote:
>> > On Fri, 2011-01-21 at 12:44 -0800, Dima Zavin wrote:
>> > > Really though? Let's look at one of them:
>> > >       2 Arve Hjønnevåg <arve@android.com>
>> > >       6 Brian Swetland <swetland@google.com>
>> > >      14 Dima Zavin <dima@android.com>
>> > >       2 Haley Teng <Haley_Teng@htc.com>
>> > >       1 Iliyan Malchev <malchev@google.com>
>> > >       5 Mike Chan <mike@android.com>
>> > I'll add this list into the commit text ..
>>
>> I think it'd be better if you pull them into a
>> git repository, then use either:
>>       git format-patch
>>       git send-email
>> or
>>       git request-pull
>>
>> That way no author history is lost.
>
> The history isn't upstreamable ..

Why is that? I don't see any technical problem of upstreaming the
original patches even if they don't compile (as long as they're not
included in Makefiles or Kconfig files). There's no need to hide the
real history even if it looks ugly...

                         Pekka
