Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229Ab1BKRf0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 12:35:26 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:60387 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756595Ab1BKRfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 12:35:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=IOiKpi8kRKFIxMOjzRqvfmwOwpxj3r8ORybwYchPE/XFiHg3btmn0/O9VOgyZU/9Sm
         vVsB99OQnVkWVV/cpGYeDltYqlEpY+l5UKzFyXPxfc7W5VCfIHB0jVvq+GHBrG+Y4Uz5
         ynhfrqZ8jVQzAGGXpiX2b5h1Kif3lanLG0PTc=
Message-ID: <4D557356.1050709@gmail.com>
Date: Fri, 11 Feb 2011 20:35:18 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64: disable identity mappings statically
References: <1297432830-3912-1-git-send-email-jolsa@redhat.com> <m14o8a34em.fsf@fess.ebiederm.org> <20110211170722.GA2010@jolsa.brq.redhat.com>
In-Reply-To: <20110211170722.GA2010@jolsa.brq.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2011 08:07 PM, Jiri Olsa wrote:
> On Fri, Feb 11, 2011 at 08:46:41AM -0800, Eric W. Biederman wrote:
>> Jiri Olsa <jolsa@redhat.com> writes:
>>
>>> hi,
>>>
>>> while browsing the page table setup code, I noticed the x86_64 head
>>> code might not need the identity mappings at all.
>>> It seems it's ok to switch it off completely from the begining,
>>> unless I'm missing something.
>>
>> Have you tested it?
> 
> yes, I booted it with no problem
> 

Hi Jiri, just wonder -- hibernation still works after that?
Also Xen might/might-not need it as well, and walk_pgd_level
seems to use it as well, no?

-- 
    Cyrill
