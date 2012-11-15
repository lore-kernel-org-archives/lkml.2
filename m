Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756416Ab2KOIpA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 03:45:00 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:54813 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970Ab2KOIo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 03:44:58 -0500
X-AuditID: 9c930197-b7b45ae000000e9e-98-50a4ab89727b
From: Namhyung Kim <namhyung@kernel.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 3/6] perf ui/gtk: Implement ui_progress functions
References: <1352813436-14173-1-git-send-email-namhyung@kernel.org>
	<1352813436-14173-3-git-send-email-namhyung@kernel.org>
	<alpine.LFD.2.02.1211150945340.2386@tux.localdomain>
Date: Thu, 15 Nov 2012 17:44:56 +0900
In-Reply-To: <alpine.LFD.2.02.1211150945340.2386@tux.localdomain> (Pekka
	Enberg's message of "Thu, 15 Nov 2012 09:47:23 +0200 (EET)")
Message-ID: <871ufvmf07.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pekka,

On Thu, 15 Nov 2012 09:47:23 +0200 (EET), Pekka Enberg wrote:
> On Tue, 13 Nov 2012, Namhyung Kim wrote:
>> From: Namhyung Kim <namhyung.kim@lge.com>
>> 
>> Implement progress update function for GTK2 front end.
>> 
>> Note that since it will be called before gtk main loop so that
>> we should call gtk event loop handler directly.
>> 
[snip]
>
> When is the progress bar shown? Why does it need to be a separate dialog? 
> Can't we embed it in the current perf window (and make the other 
> UI components disabled if necessary)?

It's called during perf_session__process_events() which is executed
before creating the main window.

Thanks,
Namhyung
