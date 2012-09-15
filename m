Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966Ab2IOXJN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2012 19:09:13 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:40617 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751186Ab2IOXJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2012 19:09:11 -0400
MIME-Version: 1.0
X-Originating-IP: [187.113.203.103]
From: Matthias Diener <matthias.diener@mdiener.org>
Date: Sat, 15 Sep 2012 20:08:39 -0300
Message-ID: <CAKBUcnA4b8HaV3-20C8QXXgFXW4ZDfOc6SvYCFsA3mtdyEd89Q@mail.gmail.com>
Subject: Re: [PATCH v5] hashtable: introduce a small and naive hashtable
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sasha Levin (levinsasha928 <at> gmail.com) wrote:
>On Sat, Sep 15, 2012 at 5:14 PM, Mathieu Desnoyers
><mathieu.desnoyers <at> efficios.com> wrote:
>> * Sasha Levin (levinsasha928 <at> gmail.com) wrote:
[...]
>>> +#define hash_init(hashtable)                                                 \
>>> +({                                                                           \
>>> +     int __i;                                                                \
>>> +                                                                             \
>>> +     for (__i = 0; __i < HASH_BITS(hashtable); __i++)                        \
>>
>> I think this fails to initialize the whole table. You'd need
>>
>>   HASH_BITS -> HASH_SIZE
>
>Right.
>
>Unfortunately it's pretty hard catching something like this :/
>
>> Which brings the following question: how did you test this code ? It
>> would be nice to have a small test module along with this patchset that
>> stress-tests this simple hash table in various configurations (on stack,
>> in data, etc).
>
>I do two things:
>
> - A small userspace test (since this header works just fine from
>userspace as well).


It would be interesting to run some experiments with this hashtable in
userspace.
Could you post the test code here?

Thanks,
Matthias
