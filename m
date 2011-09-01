Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932168Ab1IAV6q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 17:58:46 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:55476 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757961Ab1IAV6p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 17:58:45 -0400
MIME-Version: 1.0
In-Reply-To: <20110521204148.GB10330@ghostprotocols.net>
References: <1305968203-14240-1-git-send-email-jim.cromie@gmail.com>
 <1305968203-14240-2-git-send-email-jim.cromie@gmail.com> <20110521103418.GB23651@elte.hu>
 <20110521204148.GB10330@ghostprotocols.net>
From: Jim Cromie <jim.cromie@gmail.com>
Date: Thu, 1 Sep 2011 15:58:13 -0600
Message-ID: <CAJfuBxzhjhuGRfqW-qXFhNN+X6n_puaVS+-AbZN2NjUQGou3Jw@mail.gmail.com>
Subject: Re: [PATCH 1/2] perf stat: add -l <N> option to redirect stderr elsewhere
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, paulus@samba.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 21, 2011 at 2:41 PM, Arnaldo Carvalho de Melo
<acme@ghostprotocols.net> wrote:
> Em Sat, May 21, 2011 at 12:34:18PM +0200, Ingo Molnar escreveu:
>>
>> * Jim Cromie <jim.cromie@gmail.com> wrote:
>>
>> > This perf stat option emulates valgrind's --log-fd option, allowing the
>> > user to send perf results elsewhere, and leaving stderr for use by the
>> > program under test.
>> >
>> >   3>results perf stat -l 3 -- <cmd>
>> >
>> > The perl distro's make test.valgrind target uses valgrinds --log-fd
>> > option, I've adapted it to invoke perf also, and tested this patch there.
>> >
>> > Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
>>
>> Makes sense!
>>
>> Arnaldo, if you are fine with it, do you want to pick it up - or should i? If
>> you pick it up:
>>
>> Acked-by: Ingo Molnar <mingo@elte.hu>
>
> Its ok with me:
>
> Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
>
> I will pick it this weekend, if you don't merge it till then.
>
> - Arnaldo
>

Did this ever happen ?
Can you point me to the git-url where it did/will end up ?
