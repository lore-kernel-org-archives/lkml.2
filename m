Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab1EPSAu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 14:00:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47255 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753934Ab1EPSAt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 14:00:49 -0400
Message-ID: <4DD16639.8060604@zytor.com>
Date: Mon, 16 May 2011 11:00:25 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Greg KH <greg@kroah.com>, Ingo Molnar <mingo@elte.hu>,
        Randy Dunlap <rdunlap@xenotime.net>, Frank Arnold <farnold@amd64.org>,
        X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Hagen Paul Pfeifer <hagen@jauu.net>
Subject: Re: [PATCH 1/3] x86, AMD, cacheinfo: Fix fallout caused by max3 conversion
References: <1305553188-21061-1-git-send-email-bp@amd64.org> <1305553188-21061-2-git-send-email-bp@amd64.org> <20110516173128.GC13011@kroah.com> <20110516173816.GE22383@aftab> <4DD16221.1090000@zytor.com> <20110516174743.GF22383@aftab>
In-Reply-To: <20110516174743.GF22383@aftab>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2011 10:47 AM, Borislav Petkov wrote:
> On Mon, May 16, 2011 at 01:42:57PM -0400, H. Peter Anvin wrote:
>> So are you asking for this patchset to go into .39 or .40?
> 
> .39 please, if possible.
> 

At this point, ".39 and not stable" is basically an oxymoron (especially
since .39 might very well be out before this patch makes it to Linus),
so please clarify what you mean, then.

	-hpa
