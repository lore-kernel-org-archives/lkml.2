Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471Ab2DQCRG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 22:17:06 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:48667 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692Ab2DQCRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 22:17:03 -0400
X-AuditID: 9c930179-b7b2cae000000ca1-fe-4f8cd29c67bc
From: Namhyung Kim <namhyung.kim@lge.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, acme@redhat.com, mingo@elte.hu,
        paulus@samba.org, cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, andi@firstfloor.org
Subject: Re: [RFCv2 0/8] perf tool: Add new event group management
References: <1333574176-11388-1-git-send-email-jolsa@redhat.com>
	<1334503015.28150.16.camel@twins>
	<20120416121627.GA1660@m.brq.redhat.com>
	<1334589962.28150.69.camel@twins>
	<20120416153739.GB1660@m.brq.redhat.com>
Date: Tue, 17 Apr 2012 11:16:32 +0900
In-Reply-To: <20120416153739.GB1660@m.brq.redhat.com> (Jiri Olsa's message of
	"Mon, 16 Apr 2012 17:37:39 +0200")
Message-ID: <87pqb7cdbz.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 16 Apr 2012 17:37:39 +0200, Jiri Olsa wrote:
> On Mon, Apr 16, 2012 at 05:26:02PM +0200, Peter Zijlstra wrote:
>> On Mon, 2012-04-16 at 14:16 +0200, Jiri Olsa wrote:
>> > group:        group_spec '{' events '}'
>> > group_spec:   name  ':' mod | empty 
>> 
>> How about something like:
>> 
>> groups: groups ',' group | group
>> group:	group_name '{' events '}' group_mod
>> group_name: name ':' | empty
>> group_mod: ':' group_mods | empty
>> group_mods: [l]
>> 
>> 
>
> so you'd like something like:
>   'group1:{cycles,faults}:1
>
> hm, do you want the ':' behind the name? It does not seem necessary,
> but might be readable though.. ok :)
>   'group1{cycles,faults}:1
>

+1 for the last form :)

Thanks,
Namhyung
