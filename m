Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529Ab1KXDIL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 22:08:11 -0500
Received: from dns1.mips.com ([12.201.5.69]:53507 "EHLO dns1.mips.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754828Ab1KXDIK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 22:08:10 -0500
Message-ID: <4ECDB4C1.30006@mips.com>
Date: Thu, 24 Nov 2011 11:06:41 +0800
From: Deng-Cheng Zhu <dczhu@mips.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: "Barzilay, Eyal" <eyal@mips.com>, "Fortuna, Zenon" <zenon@mips.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "ralf@linux-mips.org" <ralf@linux-mips.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 5/5] perf: Enable applicable siblings when group leader
 is enable-on-exec
References: <1321932601-21128-1-git-send-email-dczhu@mips.com>	 ,<1321959115.5148.22.camel@twins>	 <BD04AF0D5BE72443A0B69C1C0486AD3ECE8DA82C@exchdb03.mips.com>	 ,<1321969559.14799.7.camel@twins>	 <BD04AF0D5BE72443A0B69C1C0486AD3ECE8DA871@exchdb03.mips.com>	 <1321971798.14799.12.camel@twins> <4ECC6AAC.4010504@mips.com>	,<1322048382.14799.41.camel@twins>	 <BD04AF0D5BE72443A0B69C1C0486AD3ECE8DA9FF@exchdb03.mips.com> <1322052511.14799.61.camel@twins>
In-Reply-To: <1322052511.14799.61.camel@twins>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-EMS-Proccessed: 6LP3oGfGVdcdb8o1aBnt6w==
X-EMS-STAMP: 0ikYwNu7EXO8+KcwnaDJUA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2011 08:48 PM, Peter Zijlstra wrote:
> On Wed, 2011-11-23 at 12:40 +0000, Zhu, DengCheng wrote:
>>
>> Ah, yes you are right. Thanks. Your following patch looks good except
>> that event_entry should be used for ctx event_list, rather than
>> group_entry.
>
> D'0h yes, I figure the next compile cycle would've caught that. Fixed it
> though, thanks!

I tested it this morning. It passed my cases :) You may also add my:

Tested-by: Deng-Cheng Zhu <dczhu@mips.com>


Deng-Cheng
