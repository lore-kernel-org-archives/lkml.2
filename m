Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113Ab2F2Bhy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 21:37:54 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:50567 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755900Ab2F2Bhx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 21:37:53 -0400
X-AuditID: 9c93016f-b7c85ae00000559e-cb-4fed06efbb0b
From: Namhyung Kim <namhyung@kernel.org>
To: Jovi Zhang <bookjovi@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>, acme@ghostprotocols.net,
        a.p.zijlstra@chello.nl, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] perf, tool: Fix hw breakpoint's type modifier parsing
References: <20120628103223.GA1055@krava.redhat.com>
	<1340918329-3012-1-git-send-email-jolsa@redhat.com>
	<1340918329-3012-2-git-send-email-jolsa@redhat.com>
	<87hatvx84w.fsf@sejong.aot.lge.com>
	<CACV3sb+ykMp0n_c7GwETPnT8bV5UWnM=bVdh3DakNKksK2QNWA@mail.gmail.com>
Date: Fri, 29 Jun 2012 10:34:06 +0900
In-Reply-To: <CACV3sb+ykMp0n_c7GwETPnT8bV5UWnM=bVdh3DakNKksK2QNWA@mail.gmail.com>
	(Jovi Zhang's message of "Fri, 29 Jun 2012 09:01:05 +0800")
Message-ID: <87y5n6x5o1.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Jun 2012 09:01:05 +0800, Jovi Zhang wrote:
> On Fri, Jun 29, 2012 at 8:40 AM, Namhyung Kim <namhyung@kernel.org> wrote:
>> On Thu, 28 Jun 2012 23:18:48 +0200, Jiri Olsa wrote:
>>> Fixing the hw breakpoint's type modifier parsing to allow all
>>> possible combinations of 'rwx' characters.
>>>
>>> Adding automated tests to the parsing test suite.
>>>
>>
>> You might need this too:
>>
>>  Reported-by: Zovi Zhang <bookzovi@gmail.com>
>>
>> Thanks,
>> Namhyung
>>
>
> Thanks Namhyung, Jovi Zhang <bookjovi@gmail.com> :)

Oops, sorry about that. ;-)

Thanks,
Namhyung
