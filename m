Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751272Ab2JQEWg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 00:22:36 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:65508 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab2JQEWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 00:22:35 -0400
X-AuditID: 9c930197-b7c4aae000004160-f1-507e328884c5
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Irina Tirdea <irina.tirdea@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        David Ahern <dsahern@gmail.com>, Pekka Enberg <penberg@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>,
        Irina Tirdea <irina.tirdea@intel.com>
Subject: Re: [PATCH v4 4/6] perf tools: Try to find cross-built objdump path
References: <1350344020-8071-1-git-send-email-irina.tirdea@gmail.com>
	<1350344020-8071-5-git-send-email-irina.tirdea@gmail.com>
	<20121016152619.GE6807@ghostprotocols.net>
Date: Wed, 17 Oct 2012 13:22:31 +0900
In-Reply-To: <20121016152619.GE6807@ghostprotocols.net> (Arnaldo Carvalho de
	Melo's message of "Tue, 16 Oct 2012 08:26:19 -0700")
Message-ID: <87bog13eyg.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo and Irina,

On Tue, 16 Oct 2012 08:26:19 -0700, Arnaldo Carvalho de Melo wrote:
> Em Tue, Oct 16, 2012 at 02:33:38AM +0300, Irina Tirdea escreveu:
>> From: Namhyung Kim <namhyung.kim@lge.com>
>
> Well, by now it is not anymore from Namhyung, but based on a previous
> patch by him, right?
>
> I'm ok with the patch, thanks for addressing my suggestions, but please
> resubmit with you as the patch author, giving credit for the original
> patch by Namhyung.
>
> Namhyung, are you ok with it? If so could I have a reviewed-by from you
> or at least an acked-by? The SOB is to be dropped, as this is not coming
> from you, but directly from Irina and as explained above, its a modified
> patch.

Sure.  Please feel free to add my

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung

