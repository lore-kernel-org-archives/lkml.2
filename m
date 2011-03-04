Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759274Ab1CDJln (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 04:41:43 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:55585 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834Ab1CDJlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 04:41:42 -0500
Message-ID: <4D70B3E1.8020108@dcl.info.waseda.ac.jp>
Date: Fri, 04 Mar 2011 18:41:53 +0900
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:2.0b10pre) Gecko/20110114 Thunderbird/3.3a2
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        h.mitake@gmail.com, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] perf lock: clean the options for perf record
References: <1298388507-19774-1-git-send-email-mitake@dcl.info.waseda.ac.jp> <4D63D685.2010401@dcl.info.waseda.ac.jp> <1298389415.2217.243.camel@twins> <20110222182206.GB1799@nowhere> <4D648A65.2040107@dcl.info.waseda.ac.jp> <4D667D60.5010903@dcl.info.waseda.ac.jp> <20110224165014.GB1840@nowhere> <4D67E286.8010907@dcl.info.waseda.ac.jp> <AANLkTikUGO=Obm7Ue4VzEueQ7DERPiwci1VV9NmKZf1u@mail.gmail.com>
In-Reply-To: <AANLkTikUGO=Obm7Ue4VzEueQ7DERPiwci1VV9NmKZf1u@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/11 23:55, Frederic Weisbecker wrote:
> On Sat, Feb 26, 2011 at 02:10:30AM +0900, Hitoshi Mitake wrote:
>> It seems that I was too preprocessed with the method and
>> forgot the purpose...
>>
>> Maybe the things like simple lockstat visualizer or
>> special diff between two lockstat snapshots are
>> useful for the first looking at big picture.
>> I feel that they have worth to write and test.
>
> Indeed they sound like good ideas. Being able to do a diff
> on locks profiles would be useful to compare two changes on
> the kernel.
>

BTW, how do you think about the idea of exporting data in
python (or other neutral) expression from procfs? I feel it is a
good idea. Communicating with unified format between user space and
kernel space will reduce lots of parsing overhead. Is this too
aggressive or insane?
