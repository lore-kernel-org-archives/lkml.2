Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757115Ab1I2Pv7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 11:51:59 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:54183 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757101Ab1I2Pv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 11:51:58 -0400
MIME-Version: 1.0
In-Reply-To: <6324.1317308270@redhat.com>
References: <CAOH1cHnymZ1WasD4q+HXbeQb9wBAWmS9f451gEekA0-YjCZtLA@mail.gmail.com>
	<2150.1314882260@redhat.com>
	<CAOH1cHnLfLQzZ8022ivfFkbug=adU1AYZPJOqdTnrqh9vuAAxg@mail.gmail.com>
	<CAOH1cHm-hbC=KZJsT1H5ohVEJVzNvqaKatKVS+s2nKVkAMgX9w@mail.gmail.com>
	<5149.1317036720@redhat.com>
	<CAOH1cHn3QF0QtR7KKN9gk5CiUvLqxsni0yi9bgCmJ8f=N1v27Q@mail.gmail.com>
	<CAOH1cHmTWdCHAprmbH7cfmZCVakdayR3jd031da2X2N3FmjfPw@mail.gmail.com>
	<6324.1317308270@redhat.com>
Date: Thu, 29 Sep 2011 08:51:57 -0700
Message-ID: <CAOH1cHn0tc-_dFe1PovpKmTE5pnMp40ZXi5TR9+i=ozviTdinA@mail.gmail.com>
Subject: Re: [Linux-cachefs] 3.0.3 64-bit Crash running fscache/cachefilesd
From: Mark Moseley <moseleymark@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: Linux filesystem caching discussion list 
	<linux-cachefs@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 7:57 AM, David Howells <dhowells@redhat.com> wrote:
> Mark Moseley <moseleymark@gmail.com> wrote:
>
>> Ok, this just popped 15 mins ago. Here's the trace. Some went to IPMI,
>> some made it to the logs, so I'll post both (logs first):
>>
>> [12999.564897] FS-Cache: Cookie 'NFS.fh' still has outstanding reads
>
> Hopefully the patch set I sent to you will deal with this.
>
> David

Not sure what you mean. Was there another patch besides the one to get
more info in the traceback?
