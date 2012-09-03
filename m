Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692Ab2ICU7x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 16:59:53 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:37968 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282Ab2ICU7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 16:59:52 -0400
MIME-Version: 1.0
In-Reply-To: <87y5krewud.fsf@sejong.aot.lge.com>
References: <CANg8OW+Y3ZMG-GdhYu2_yKOYH_XEMgw73PdCX_23UTnfYhmttA@mail.gmail.com>
 <87y5krewud.fsf@sejong.aot.lge.com>
From: Irina Tirdea <irina.tirdea@gmail.com>
Date: Mon, 3 Sep 2012 23:59:31 +0300
Message-ID: <CANg8OW+kSCuosD0Uke0w+Lxdk_Z+FRauBiyUmj4STCcNEDzzCQ@mail.gmail.com>
Subject: Re: [PATCH 11/13] perf tools: replace mempcpy with memcpy
To: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 3, 2012 at 4:09 AM, Namhyung Kim <namhyung@kernel.org> wrote:
> On Wed, 29 Aug 2012 01:22:16 +0300, Irina Tirdea wrote:
>> mempcpy is not supported by bionic in Android
>> and will lead to compilation errors.
>>
>> Replacing mempcpy with memcpy so it will work in Android.
>
> Unfortunately I've added another instance of the mempcpy in a
> libtraceevent code. :-/
>

Thanks for the heads-up. I'll fix it.

Irina

> Thanks,
> Namhyung
>
