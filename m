Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749Ab1AMNSL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 08:18:11 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:41123 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756285Ab1AMNSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 08:18:09 -0500
X-AuditID: b753bd60-9d28dba000000ca4-91-4d2efb8e680b
Message-ID: <4D2EFB8A.5050105@hitachi.com>
Date: Thu, 13 Jan 2011 22:18:02 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Franck Bui-Huu <fbuihuu@gmail.com>, linux-kernel@vger.kernel.org,
        2nddept-manager@sdl.hitachi.co.jp, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH -perf/perf/core 4/6] perf: Add strfilter for general purpose
 string filter
References: <20110113124548.22426.11201.stgit@ltc236.sdl.hitachi.co.jp>	 <20110113124617.22426.25293.stgit@ltc236.sdl.hitachi.co.jp> <1294923701.19601.108.camel@laptop>
In-Reply-To: <1294923701.19601.108.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/01/13 22:01), Peter Zijlstra wrote:
> On Thu, 2011-01-13 at 21:46 +0900, Masami Hiramatsu wrote:
>> Format:
>> <rule> ::= <glob-exp> | "!" <rule> | <rule> <op> <rule> | "(" <rule> ")"
>> <op> ::= "&" | "|"
>>
>> e.g.
>>  "(add* | del*) & *timer" filter rules pass strings which
>>  start with add or del and end with timer. 
> 
> Why not simply use regexps?

IMHO, regexp is usually too complex and too powerful just for
filtering and the combination of wild cards are simple and enough. :)
Moreover, if you'd like to filter with regexp, you just can use
"| grep" or "| egrep". ;)

(Of course, it is possible to expand this filter to support regexp by simply
 adding "~REGEXP" rule as ftrace does)

Thank you,

-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
