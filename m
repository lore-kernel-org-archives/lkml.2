Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766Ab2KMUBo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 15:01:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36278 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755693Ab2KMUBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 15:01:43 -0500
Message-ID: <50A2A706.1090608@zytor.com>
Date: Tue, 13 Nov 2012 12:01:10 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Jacob Shin <jacob.shin@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 21/46] x86, mm: setup page table in top-down
References: <20121112193044.GA11615@phenom.dumpdata.com> <1352755122-25660-1-git-send-email-yinghai@kernel.org> <1352755122-25660-22-git-send-email-yinghai@kernel.org> <alpine.DEB.2.02.1211131707380.28049@kaball.uk.xensource.com> <CAE9FiQU1HGyw8ZLu8KdmR3ikyZ=YTG+8dUoDAVbO4Bc1hEPPgQ@mail.gmail.com>
In-Reply-To: <CAE9FiQU1HGyw8ZLu8KdmR3ikyZ=YTG+8dUoDAVbO4Bc1hEPPgQ@mail.gmail.com>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2012 11:59 AM, Yinghai Lu wrote:
>>
>> The changes to init_mem_mapping are a bit iffy but they aren't too
>> unreasonable.
>> Overall the patch is OK even though I would certainly appreciate more
>> comments and better variable names (real_end?), see below.
> 
> real_end is not good?
> 
> xen put big reserved range between real_end and end.
> 
> that real_end is some kind of end of real usable areas.
> 
> so change to real_usable_end  or usable_end?
> 

A description of a variable that includes the words "some kind of"
clearly indicates major confusion.  We need to know what the semantics
are, here.

	-hpa

