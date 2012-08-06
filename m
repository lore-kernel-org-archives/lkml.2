Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751441Ab2HFEWb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 00:22:31 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:42079 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091Ab2HFEVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 00:21:49 -0400
X-AuditID: 9c930197-b7b66ae000006a2c-86-501f465ad273
From: Namhyung Kim <namhyung@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Namhyung Kim <namhyung.kim@lge.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ulrich Drepper <drepper@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 03/18] perf target: Fix check on buffer size
References: <1344002470-5965-1-git-send-email-acme@infradead.org>
	<1344002470-5965-4-git-send-email-acme@infradead.org>
	<20120803141703.GA19736@shutemov.name>
	<87vcgwznen.fsf@sejong.aot.lge.com> <501F44B2.4010703@gmail.com>
Date: Mon, 06 Aug 2012 13:15:41 +0900
In-Reply-To: <501F44B2.4010703@gmail.com> (David Ahern's message of "Sun, 05
	Aug 2012 22:14:42 -0600")
Message-ID: <87r4rkzmdu.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, David

On Sun, 05 Aug 2012 22:14:42 -0600, David Ahern wrote:
> On 8/5/12 9:53 PM, Namhyung Kim wrote:
>>
>> I think this should go to the urgent branch too as the offending patch
>> seemed to go to the mainline already.
>>
>
> It was picked up by Ingo today and included in his pull request sent
> to Linus.
>

Oh, I didn't see the mail for some reason. Thanks for pointing it out.

Thanks,
Namhyung
