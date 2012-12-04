Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab2LDOvN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 09:51:13 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:40599 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398Ab2LDOvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 09:51:09 -0500
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 12/18] perf ui/hist: Add support for event group view
References: <1354171126-14387-1-git-send-email-namhyung@kernel.org>
	<1354171126-14387-14-git-send-email-namhyung@kernel.org>
	<20121130132943.GC1080@krava.brq.redhat.com>
	<20121130135215.GG1957@ghostprotocols.net>
	<CAM9d7cgZMfbYOdcELNXdGPT9tOzbKLZbNWjZ8g3Sug6_88pGnA@mail.gmail.com>
	<20121204135049.GC3159@ghostprotocols.net>
Date: Tue, 04 Dec 2012 23:51:00 +0900
In-Reply-To: <20121204135049.GC3159@ghostprotocols.net> (Arnaldo Carvalho de
	Melo's message of "Tue, 4 Dec 2012 10:50:49 -0300")
Message-ID: <87k3sxc1m3.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

On Tue, 4 Dec 2012 10:50:49 -0300, Arnaldo Carvalho de Melo wrote:
> Em Tue, Dec 04, 2012 at 06:16:59PM +0900, Namhyung Kim escreveu:
>> On Fri, Nov 30, 2012 at 10:52 PM, Arnaldo Carvalho de Melo wrote:
>
>> Ah, I missed your point.  Just got it now, will try this approach.  So
>> you want to see no "0.00%" for a dummy entry, right?
>
> That wasn't the point, and perhaps printing 0.00% pollutes the screen
> needlessly or may be a help in seeing the columns more clearly, no
> strong opinion at this point, please experiment.
>
> The point was that there seems to be no need for the temporary array.

Yeah, it shows my really bad writing skill. :(

I meant I got your point of not using a temporary array.  And asked
additional question of your preference in a dummy entry.

Sorry for confusing you.

Btw, I found that printing 0.00% is useful for a case of field_sep and
GTK+ output.  So unless someone objects, I'll keep it.

Thanks,
Namhyung
