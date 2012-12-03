Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751404Ab2LCSJ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 13:09:28 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37960 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059Ab2LCSJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 13:09:27 -0500
MIME-Version: 1.0
In-Reply-To: <50BCD5CB.2030506@suse.cz>
References: <1354551724-15089-1-git-send-email-js1304@gmail.com>
	<1354551724-15089-2-git-send-email-js1304@gmail.com>
	<50BCD5CB.2030506@suse.cz>
Date: Tue, 4 Dec 2012 03:09:26 +0900
Message-ID: <CAAmzW4ND7n6z14hLPL72Hmf2QX4n=gRO6huLNbeVbmQo7kZuOg@mail.gmail.com>
Subject: Re: [PATCH 2/2] scripts/tags.sh: Support compiled source
From: JoonSoo Kim <js1304@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/12/4 Michal Marek <mmarek@suse.cz>:
> On 3.12.2012 17:22, Joonsoo Kim wrote:
>> We usually have interst in compiled files only,
>> because they are strongly related to individual's work.
>> Current tags.sh can't select compiled files, so support it.
>>
>> We can use this functionality like below.
>> "make cscope O=. SRCARCH=xxxx SUBARCH=compiled"
>
> I like the idea, but please try to come up with a different syntax that
> does not abuse SUBARCH.
>
>
>> +all_compiled_sources()
>> +{
>> +     for i in $(all_sources); do
>> +             if [[ $i =~ .*c$ || $i =~ .*S$ ]]; then
>> +                     j=${i/\.[cS]/\.o}
>
> Please use 'case "$i" in ...' instead of the bash-specific [[ ... ]]
> construct.

I send v2 which is fixed according to your comment.
Thanks for review.
