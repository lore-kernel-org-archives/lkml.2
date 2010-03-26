Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934Ab0CZPop (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 11:44:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42329 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751028Ab0CZPon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 11:44:43 -0400
Message-ID: <4BACD64F.4090005@redhat.com>
Date: Fri, 26 Mar 2010 11:44:15 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc11 Thunderbird/3.0.3
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Andrea Gelmini <andrea.gelmini@gelma.net>, linux-doc@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/16] Tools perf probe-finder.c: duplicated include
References: <1269537767-7553-14-git-send-email-andrea.gelmini@gelma.net> <4BABA088.2000405@redhat.com> <20100326142933.6CA7.A69D9226@jp.fujitsu.com>
In-Reply-To: <20100326142933.6CA7.A69D9226@jp.fujitsu.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
>> Hi Andrea,
>>
>> Andrea Gelmini wrote:
>>> tools/perf/util/probe-finder.c: string.h is included more than once.
>>
>> Would you mean that <string.h> and "string.h" are duplicated? 
>> If so, NAK, sorry. Those are different, <string.h> is for
>> /usr/include/string.h, and "string.h" is for tools/perf/util/string.h.
>>
>> Thank you,
> 
> I think this discussion suggested "string.h" should be renameed more review
> friendly name. probably.

Hmm, we'd better review files under tools/utils/include too. :(
(not sure why we have those files, because some files includes
 headers from original include directory, as like as 
 "../../include/linux/blahblah.h")

Thank you,

-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
