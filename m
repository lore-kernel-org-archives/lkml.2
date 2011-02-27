Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979Ab1B0JoH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 04:44:07 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:49563 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908Ab1B0JoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 04:44:03 -0500
X-AuditID: b753bd60-a3b4cba0000001d0-e3-4d6a1cdf9cf6
X-AuditID: b753bd60-a3b4cba0000001d0-e3-4d6a1cdf9cf6
Message-ID: <4D6A1CDB.4040908@hitachi.com>
Date: Sun, 27 Feb 2011 18:43:55 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCH -perf/perf/makefile  0/2] Perf bugfixes for cross-builds
References: <20110210022847.15395.31441.stgit@ltc236.sdl.hitachi.co.jp> <4D63A642.5090203@hitachi.com> <20110222121139.GB27070@ghostprotocols.net>
In-Reply-To: <20110222121139.GB27070@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/02/22 21:11), Arnaldo Carvalho de Melo wrote:
> Em Tue, Feb 22, 2011 at 09:04:18PM +0900, Masami Hiramatsu escreveu:
>> Hi Arnaldo,
>>
>> BTW, could you pull these patches for cross building?
> 
> I'll try again to use this new feature, sorry for not sending feedback,
> but I failed to use it on a RHEL6 system, have to try again and provide
> proper feedback.

Hmm, would you install some devel packages for i686 too?
This change requires 32bits devel packages for cross building.

Thank you,

>  
>> (2011/02/10 11:28), Masami Hiramatsu wrote:
>>> Hi,
>>>
>>> Here are some bugfixes related to cross builds.
>>> - Introduce ARCH=XX for cross-builds instead of obsolate
>>>   EXTRA_CFLAGS=-mXX option.
>>> - Rename obsolate NO_PERL to NO_LIBPERL
>>>
>>> Still not sure how I can do cross-builds i386 binary with
>>> perl/python support on x86-64. Anyway, now we can do without
>>> that as below;
>>>
>>>  $ make ARCH=i386 NO_LIBPERL=1 NO_LIBPYTHON=1
>>>
>>> Thank you,
>>>
>>> ---
>>>
>>> Masami Hiramatsu (2):
>>>       perf tools: Rename old NO_PERL option to NO_LIBPERL
>>>       perf tools: Introduce ARCH= option for cross building
>>>
>>>
>>>  tools/perf/Makefile              |   48 +++++++++++++++++++++++++-------------
>>>  tools/perf/arch/arm/Makefile     |    2 +-
>>>  tools/perf/arch/powerpc/Makefile |    2 +-
>>>  tools/perf/arch/s390/Makefile    |    2 +-
>>>  tools/perf/arch/sh/Makefile      |    2 +-
>>>  tools/perf/arch/sparc/Makefile   |    2 +-
>>>  tools/perf/arch/x86/Makefile     |    2 +-
>>>  7 files changed, 38 insertions(+), 22 deletions(-)
>>>
>>
>>
>> -- 
>> Masami HIRAMATSU
>> 2nd Dept. Linux Technology Center
>> Hitachi, Ltd., Systems Development Laboratory
>> E-mail: masami.hiramatsu.pt@hitachi.com


-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
