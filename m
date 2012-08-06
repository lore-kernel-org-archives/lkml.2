Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600Ab2HFD7p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 23:59:45 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:52182 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755563Ab2HFD7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 23:59:44 -0400
X-AuditID: 9c93016f-b7b08ae00000790d-42-501f412e8941
From: Namhyung Kim <namhyung@kernel.org>
To: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Namhyung Kim <namhyung.kim@lge.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ulrich Drepper <drepper@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 03/18] perf target: Fix check on buffer size
References: <1344002470-5965-1-git-send-email-acme@infradead.org>
	<1344002470-5965-4-git-send-email-acme@infradead.org>
	<20120803141703.GA19736@shutemov.name>
Date: Mon, 06 Aug 2012 12:53:36 +0900
In-Reply-To: <20120803141703.GA19736@shutemov.name> (Kirill A. Shutemov's
	message of "Fri, 3 Aug 2012 17:17:03 +0300")
Message-ID: <87vcgwznen.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Arnaldo

On Fri, 3 Aug 2012 17:17:03 +0300, Kirill A. Shutemov wrote:
> On Fri, Aug 03, 2012 at 11:00:55AM -0300, Arnaldo Carvalho de Melo wrote:
>> From: Namhyung Kim <namhyung.kim@lge.com>
>> 
>> It was a mistake just replace assert to BUG_ON since its condition
>> should be negated. Fix it.
>> 
>> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
>> Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
>> Cc: Ingo Molnar <mingo@kernel.org>
>> Cc: Kirill A. Shutemov <kirill@shutemov.name>
>> Cc: Paul Mackerras <paulus@samba.org>
>> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
>> Cc: Ulrich Drepper <drepper@gmail.com>
>> Link: http://lkml.kernel.org/r/1343267410-7758-1-git-send-email-namhyung@kernel.org
>> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
>
> Acked-by: Kirill A. Shutemov <kirill@shutemov.name>

I think this should go to the urgent branch too as the offending patch
seemed to go to the mainline already.

Thanks,
Namhyung
