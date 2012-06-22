Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933169Ab2FVPfv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 11:35:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56762 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762563Ab2FVPfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 11:35:48 -0400
Message-ID: <4FE490C9.1020903@gmail.com>
Date: Fri, 22 Jun 2012 09:35:37 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@gmail.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC/PATCHSET 0/8] perf tools: Minimal build without libelf dependency
 (v2)
References: <1340343462-15556-1-git-send-email-namhyung@kernel.org>  <1340358478.18025.51.camel@twins> <1340377510.1478.10.camel@leonhard>  <4FE48CCA.2050506@gmail.com> <1340379000.1478.34.camel@leonhard>
In-Reply-To: <1340379000.1478.34.camel@leonhard>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/22/12 9:30 AM, Namhyung Kim wrote:
>> And build-id's are not required for report (-B option for record).
>>
>> Also, the intent is for a small footprint binary for embedded systems.
>> On such a system I would expect binaries and libraries to be stripped,
>> so no point in running perf-archive.
>>
>
> But is there a chance that binaries on host still contains symbol (and
> debug) information even for those cases?
>

AFAIK embedded systems do not have the luxury of symbols; the goal is as 
small as possible. All debugging information is left on the build 
servers for off line analysis. That's certainly true for the product I 
work on.

David

