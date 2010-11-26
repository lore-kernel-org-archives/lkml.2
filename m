Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133Ab0KZNrw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 08:47:52 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:45357 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479Ab0KZNrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 08:47:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=NNoNxbiaOZrOtyigONGnwfuN0G+9LaQgG7lWRRZuzRyKtUDcvx6zdV4+KUeHTDS6dF
         IOGCQIS01jbUom8XIh0OsNkjmvEgEc3JGELr54lFzZ9/mmv4mFvt3AuIEL64MacwpCiN
         HZLShLdn/jQqDYOEkGRjuNzPoddvLU2F4gaFg=
MIME-Version: 1.0
In-Reply-To: <1290776807.2145.144.camel@laptop>
References: <20101123224601.766827604@openvz.org>
	<20101123224800.294919307@openvz.org>
	<AANLkTikjfM=8xa8smgT6D_WTYC_S-JZ69iiqu8gD21sK@mail.gmail.com>
	<AANLkTin1Q0eo4mFbSCeO4RNrK8Men0Q3r_x9_dCse11Q@mail.gmail.com>
	<AANLkTimOY=58aW0OsWhTRjc5tgxNApKpReNh0hwK7SJJ@mail.gmail.com>
	<AANLkTikWB0TbCO1JLCtk03HAV0qEj63fPZ+rzViAZJS4@mail.gmail.com>
	<AANLkTik1R-4kvoE81oqTrSm6RZdO005kL_xfbqfyrnFm@mail.gmail.com>
	<AANLkTi=1nxsKR2e9MAEzbPNt66TUD9Ltd+ug+C7Jhk+Y@mail.gmail.com>
	<AANLkTin63X+2pOuRYHF0ntnB95g-MWjug-sUYAFGFnxa@mail.gmail.com>
	<1290776807.2145.144.camel@laptop>
Date: Fri, 26 Nov 2010 16:47:50 +0300
X-Google-Sender-Auth: PxhWFCpFH1qAXpoC7jmhGv9P2o8
Message-ID: <AANLkTi=QAOvkaBGpnVCusKsD1mrfdLDEexbOhokvp0Q2@mail.gmail.com>
Subject: Re: [rfc 1/3] perf, x86: P4 PMU - describe config format
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>, ming.m.lin@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 26, 2010 at 4:06 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2010-11-26 at 16:04 +0300, Cyrill Gorcunov wrote:
>> if none therad is active, single any
>> thread is active, both threads are active and finally any thread is
>> active (which is exactly 0b11 in single thread machine). i know it's
>> weird ;)
>>
> BTW, does P4 mandate SYS_CAP_ADMIN for counting another thread's events?
>
The events which are shared across threads mandated to have
SYS_CAP_ADMIN of course.
