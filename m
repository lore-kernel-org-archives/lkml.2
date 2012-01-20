Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab2ATDNS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 22:13:18 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39239 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751074Ab2ATDNR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 22:13:17 -0500
References: <4F18B911.2060601@oak.selfip.net> <CA+5PVA5U-mJKMR63=1Tc6arjhtTkFNOjvSumFiENdJRyVs1Epg@mail.gmail.com>
User-Agent: K-9 Mail for Android
In-Reply-To: <CA+5PVA5U-mJKMR63=1Tc6arjhtTkFNOjvSumFiENdJRyVs1Epg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: PROBLEM: Postgres fails to start due to kernel issue?
From: "hpanvin@gmail.com" <hpa@zytor.com>
Date: Thu, 19 Jan 2012 19:13:02 -0800
To: Josh Boyer <jwboyer@gmail.com>, Dave Haywood <tla@oak.selfip.net>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Message-ID: <534a6e5c-4c14-48bd-a9dc-d5b884daeb63@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, it almost certainly is.  Fixed in rc1.

Josh Boyer <jwboyer@gmail.com> wrote:

>On Thu, Jan 19, 2012 at 7:45 PM, Dave Haywood <tla@oak.selfip.net>
>wrote:
>> Hi,
>>
>>  I noticed after upgrading to 3.2.0-08812-gc2bc3a3 that Postgres-9.1
>server
>> fails to start with error:
>>
>> FATAL:  could not create shared memory segment: Function not
>implemented
>> DETAIL:  Failed system call was shmget(key=5432001, size=30523392,
>03600).
>>
>>  After some googling, I thought it was a SYSV shared memory sizing
>issue but
>> manually changing kernel.shmmax and kernel.shmall had no effect.
>>
>>  The problem has been introduced between 3.2.0-08694-g53999bf and
>> 3.2.0-08812-gc2bc3a3.
>>
>>  Let me know if you need any more information.  Bisecting is *very*
>slow on
>> this machine!
>
>If you run strace on it, does it fail with ENOSYS?  This might be
>related to an issue Peter just fixed.
>
>josh

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
