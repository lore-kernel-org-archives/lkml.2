Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017Ab1IYP3g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 11:29:36 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45782 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766Ab1IYP3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 11:29:35 -0400
Message-ID: <4E7F48E0.6000600@gmail.com>
Date: Sun, 25 Sep 2011 09:29:36 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Robert Richter <robert.richter@amd.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>, Don Zickus <dzickus@redhat.com>
Subject: Re: [V3][PATCH 0/7] perf, x86: Implement AMD IBS
References: <1316597423-25723-1-git-send-email-robert.richter@amd.com> <1316778523.9084.17.camel@twins> <20110923122014.GP6063@erda.amd.com> <m2hb42ki5a.fsf@firstfloor.org> <4E7F46D0.2060909@gmail.com> <20110925152607.GX7761@one.firstfloor.org>
In-Reply-To: <20110925152607.GX7761@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 09/25/2011 09:26 AM, Andi Kleen wrote:
>> What are you looking for that perf-script currently does not do?
> 
> Hmm can perf-script process raw data from the perf record?
> 
> If yes perhaps it is what I want indeed.
> 
> -Andi

yes, it is now a misnomer and should be 'perf dump' (or your suggested
'perf print-samples'). It has a set of default output fields with the
ability to customize (see the -f option for field options).

David
