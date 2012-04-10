Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758300Ab2DJAyE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 20:54:04 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:59598 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854Ab2DJAyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 20:54:03 -0400
X-AuditID: 9c93016f-b7b13ae000002492-ff-4f8384a07db1
From: Namhyung Kim <namhyung.kim@lge.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/7] trace-cmd: Small fixes and cleanups on libparsevent
References: <1333940074-19052-1-git-send-email-namhyung.kim@lge.com>
	<CAFTL4hz19R9heUjEBZMhweTHRuPzr-qf0hN=FLB9eRd-R9cPgg@mail.gmail.com>
Date: Tue, 10 Apr 2012 09:53:48 +0900
In-Reply-To: <CAFTL4hz19R9heUjEBZMhweTHRuPzr-qf0hN=FLB9eRd-R9cPgg@mail.gmail.com>
	(Frederic Weisbecker's message of "Mon, 9 Apr 2012 19:22:46 +0200")
Message-ID: <87sjgcbe5f.fsf@youngshil.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Frederic

On Mon, 9 Apr 2012 19:22:46 +0200, Frederic Weisbecker wrote:
> 2012/4/9 Namhyung Kim <namhyung.kim@lge.com>:
>> Hi, all
>>
>> This is a couple of small changes that I found during the flight back to
>> Korea :). While I'm not finished with reading the whole code, I send what
>> I have now in the hope that it'd help Frederic's unification work somewhat.
>> More might come later as I read the remaining parts.
>>
>> The patch 01 is a workaround to build trace-cmd without installing swig
>> since I don't have an internet access at that time, so it's independent
>> to others and can go separately.
>>
> Nice! I guess this should probably go into trace-cmd tree and then we
> backport later to the lib?
> Or I can carry them myself in the lib.
>

Either way is fine to me.

Thanks,
Namhyung
