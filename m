Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006Ab1AUVnB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 16:43:01 -0500
Received: from smtp-out.google.com ([74.125.121.67]:36004 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844Ab1AUVnA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 16:43:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=iUyeJpNO8trWfmjOtDSaVqvNfLQcGBkalEbuT3ejQ+dPr+1AB1UtIlylFRgaNSwFA7
         tEoYUWzMmWCv1wYpHxwA==
MIME-Version: 1.0
In-Reply-To: <1295645218.22882.2.camel@m0nster>
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
	<20110121130106.5f30908d@jbarnes-desktop>
	<1295645218.22882.2.camel@m0nster>
Date: Fri, 21 Jan 2011 13:42:56 -0800
Message-ID: <AANLkTinrGUMBqh657Y2fFCUWKDFwYsGZKb73O_iO9wzm@mail.gmail.com>
Subject: Re: [PATCH 0/7] Nexus One Support
From: Dima Zavin <dmitriyz@google.com>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Joe Perches <joe@perches.com>,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, davidb@codeaurora.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 21, 2011 at 1:26 PM, Daniel Walker <dwalker@codeaurora.org> wrote:
> On Fri, 2011-01-21 at 13:01 -0800, Jesse Barnes wrote:
>> On Fri, 21 Jan 2011 12:49:55 -0800
>> Daniel Walker <dwalker@codeaurora.org> wrote:
>>
>> > On Fri, 2011-01-21 at 12:44 -0800, Dima Zavin wrote:
>> > > Really though? Let's look at one of them:
>> > >
>> >
>> > >       2 Arve Hjønnevåg <arve@android.com>
>> > >       6 Brian Swetland <swetland@google.com>
>> > >      14 Dima Zavin <dima@android.com>
>> > >       2 Haley Teng <Haley_Teng@htc.com>
>> > >       1 Iliyan Malchev <malchev@google.com>
>> > >       5 Mike Chan <mike@android.com>
>> >
>> > I'll add this list into the commit text ..
>>
>> Sounds like a good example of a patch where you should preserve the
>> author field as well.
>
> preserve it as who ?

My main point is that the authorship of this code is VERY easy to
ascertain. It is not like a lot of other vendor code that gets thrown
over the wall as a tarball. We really do our best to follow the right
practices, give the right credits, create legible well separated
commits, etc.

--Dima
