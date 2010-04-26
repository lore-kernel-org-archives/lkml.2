Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685Ab0DZTL1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 15:11:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22826 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754090Ab0DZTL0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 15:11:26 -0400
Message-ID: <4BD5E52D.502@redhat.com>
Date: Mon, 26 Apr 2010 15:10:37 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip 2/4] perf probe: Fix to use symtab only if no	debuginfo
References: <20100421195616.24664.89980.stgit@localhost6.localdomain6> <20100421195624.24664.46214.stgit@localhost6.localdomain6> <20100426124815.GD7460@ghostprotocols.net> <4BD5E298.4020506@redhat.com> <20100426190806.GA8565@ghostprotocols.net>
In-Reply-To: <20100426190806.GA8565@ghostprotocols.net>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo Carvalho de Melo wrote:
> Em Mon, Apr 26, 2010 at 02:59:36PM -0400, Masami Hiramatsu escreveu:
>> Arnaldo Carvalho de Melo wrote:
>>> Em Wed, Apr 21, 2010 at 03:56:24PM -0400, Masami Hiramatsu escreveu:
>>>> Fix perf probe to use symtab only if there is no debuginfo,
>>>> because debuginfo has more precise information than symtab.
>>>
>>> "more precise"? Wouldn't it be "more expressive", i.e. with more
>>> information (parameter list with types, return type, location of
>>> parameters, etc), because what is common to both have the same value,
>>> i.e. the function address and size.
>>
>> Indeed. debuginfo has just more information than symtab, but
>> symtab certainly provides precise information for symbol-address.
> 
> I applied the patch, just replaced "more precise information" with "more
> information".

Thank you very much! :)

> 
> - Arnaldo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
