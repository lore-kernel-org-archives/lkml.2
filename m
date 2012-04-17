Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962Ab2DQJJx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 05:09:53 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:49629 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755890Ab2DQJJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 05:09:52 -0400
X-AuditID: 9c930179-b7b2cae000000ca1-85-4f8d33524b2b
From: Namhyung Kim <namhyung.kim@lge.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jiri Olsa <jolsa@redhat.com>, acme@redhat.com, mingo@elte.hu,
        paulus@samba.org, cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, andi@firstfloor.org
Subject: Re: [RFCv2 0/8] perf tool: Add new event group management
References: <1333574176-11388-1-git-send-email-jolsa@redhat.com>
	<1334503015.28150.16.camel@twins>
	<20120416121627.GA1660@m.brq.redhat.com>
	<1334589962.28150.69.camel@twins>
Date: Tue, 17 Apr 2012 18:09:11 +0900
In-Reply-To: <1334589962.28150.69.camel@twins> (Peter Zijlstra's message of
	"Mon, 16 Apr 2012 17:26:02 +0200")
Message-ID: <87lilud8so.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 16 Apr 2012 17:26:02 +0200, Peter Zijlstra wrote:
> On Mon, 2012-04-16 at 14:16 +0200, Jiri Olsa wrote:
>> group:        group_spec '{' events '}'
>> group_spec:   name  ':' mod | empty 
>
> How about something like:
>
> groups: groups ',' group | group
> group:	group_name '{' events '}' group_mod
> group_name: name ':' | empty
> group_mod: ':' group_mods | empty
> group_mods: [l]

Wouldn't it be better if group_mods accepts [ukhHGp] also and pass them
to all members in the group?

Thanks,
Namhyung
