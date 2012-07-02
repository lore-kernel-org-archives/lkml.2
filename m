Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932732Ab2GBJG2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 05:06:28 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39923 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932689Ab2GBJGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 05:06:24 -0400
References: <1341155183-15403-1-git-send-email-h.mitake@gmail.com> <87k3ynlzk8.fsf@sejong.aot.lge.com>
User-Agent: K-9 for Android
In-Reply-To: <87k3ynlzk8.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] perf bench: fix confused variable namings and descriptions in mem subsystem
From: Hitoshi Mitake <h.mitake@gmail.com>
Date: Mon, 02 Jul 2012 18:06:02 +0900
To: Namhyung Kim <namhyung@kernel.org>
CC: mingo@kernel.org, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Message-ID: <c1865315-643c-44da-bbae-fd96cd2912f4@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namhyung Kim <namhyung@kernel.org> wrote:

>Hi,
>
>On Mon,  2 Jul 2012 00:06:23 +0900, Hitoshi Mitake wrote:
>> As Namhyung Kim pointed, there are confused namings and descriptions
>> of words "cycle" and "clock" in mem-memset.c and mem-memcpy.c.
>>
>> With the option "-c" (or "--clock", now renamed as "--cycle"), mem
>> subsystem measures cost of memset() and memcpy() with cpu-cycles
>> event.
>>
>> But current mem subsystem source code contains lots of confused
>> variable namings and descriptions with "clock" (e.g. the variable
>> use_clock). This is a very bad style because there is another
>software
>> event named "cpu-clock". This patch replaces wrong usage of "clock"
>to
>> "cycle".
>>
>
>Could you fix the Documentation/perf-bench.txt also?
>
>Thanks,
>Namhyung

Oops, sorry. I'll send the modified version later.
--
Sent from my Android phone with K-9. Please excuse my brevity.
