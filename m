Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758693Ab2J2LUc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 07:20:32 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:60091 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758650Ab2J2LUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 07:20:31 -0400
X-AuditID: 9c930179-b7c8bae000003559-e8-508e667cff6b
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 0/5] perf dso: Separate dso symbols to separate object
References: <1351372712-21104-1-git-send-email-jolsa@redhat.com>
	<87mwz57czf.fsf@sejong.aot.lge.com>
	<20121029111328.GA1123@krava.redhat.com>
Date: Mon, 29 Oct 2012 20:20:28 +0900
In-Reply-To: <20121029111328.GA1123@krava.redhat.com> (Jiri Olsa's message of
	"Mon, 29 Oct 2012 12:13:28 +0100")
Message-ID: <87ip9t7ceb.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Oct 2012 12:13:28 +0100, Jiri Olsa wrote:
> On Mon, Oct 29, 2012 at 08:07:48PM +0900, Namhyung Kim wrote:
>> Hi Jiri,
>> 
>> On Sat, 27 Oct 2012 23:18:27 +0200, Jiri Olsa wrote:
>> > hi,
>> > separating dso related stuff into dso object plus some other symbol
>> > object cleanup. It's just a code moving, no actual change was done.
>> >
>> > Attached patches:
>> >   1/5 perf tool: Move build_id__sprintf into build-id object
>> >   2/5 perf tool: Move BUILD_ID_SIZE into build-id object
>> >   3/5 perf tool: Move hex2u64 into util object
>> >   4/5 perf tool: Move strxfrchar into string object
>> >   5/5 perf tool: Move dso_* related functions into dso object
>> 
>> Looks good to me.
>> 
>> Arnaldo, if you want, you can add my Reviewed- or Tested-by tags for this
>> series.
>
> humm, so you could compile it wth no problem..? what system are you? ;)

I just compiled your branch. :)

I'll check it again if you send out the v2.

Thanks,
Namhyung
