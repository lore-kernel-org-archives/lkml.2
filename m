Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041Ab2LCQTi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 11:19:38 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65222 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab2LCQTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 11:19:36 -0500
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 12/18] perf ui/hist: Add support for event group view
References: <1354171126-14387-1-git-send-email-namhyung@kernel.org>
	<1354171126-14387-14-git-send-email-namhyung@kernel.org>
	<20121130132943.GC1080@krava.brq.redhat.com>
	<CAM9d7ciOhUE9njWM2apYbiD-Ld3UP7JqhAzz76-DEemONR0OzA@mail.gmail.com>
	<20121203102327.GB1131@krava.redhat.com>
	<87a9tvifmk.fsf@sejong.aot.lge.com>
	<20121203155735.GC2637@krava.redhat.com>
Date: Tue, 04 Dec 2012 01:19:27 +0900
In-Reply-To: <20121203155735.GC2637@krava.redhat.com> (Jiri Olsa's message of
	"Mon, 3 Dec 2012 16:57:36 +0100")
Message-ID: <87zk1vp0q8.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Dec 2012 16:57:36 +0100, Jiri Olsa wrote:
> On Mon, Dec 03, 2012 at 07:39:31PM +0900, Namhyung Kim wrote:
>> On Mon, 3 Dec 2012 11:23:27 +0100, Jiri Olsa wrote:
>> > On Mon, Dec 03, 2012 at 10:56:28AM +0900, Namhyung Kim wrote:
>> >> On Fri, Nov 30, 2012 at 10:29 PM, Jiri Olsa <jolsa@redhat.com> wrote:
>> >> > ok, so this is the part thats common for both multi diff and group
>> >> > report and hugely depends on how we link matching hist_entry
>
> SNIP
>
>> > we discussed with Arnaldo and decided to stay with current approach and
>> > make the change later if needed.. to be able to see/meassure the benefit
>> >
>> > I made some initial attempt to workaround this and it appears to be
>> > not that bad ;) I'll repost my changes shortly..
>> 
>> Hmm.. so are you OK with this patch now?
>
> yep, well except for following macros:
>
> 	__HPP_COLOR_PERCENT_FN
> 	__HPP_ENTRY_PERCENT_FN
> 	__HPP_ENTRY_RAW_FN
>
> being so long.. any chance the main part of it being in function?
>
> Seems like '_type' is just in function name, but the '_field' might
> be the killer ;) maybe it could be 'used' in such function via PERF_HPP__*
> enums instead..?

Okay, I'll re-think about it tomorrow.

Thanks,
Namhyung
