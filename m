Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524Ab0HTRQa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 13:16:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51215 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752678Ab0HTRQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 13:16:28 -0400
Message-ID: <4C6EB823.1070300@zytor.com>
Date: Fri, 20 Aug 2010 10:15:15 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        kernel list <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>
Subject: Re: 2.6.36-rc1: Doesn't boot on an AMD-based machine
References: <201008172206.14349.rjw@sisk.pl> <201008180307.42504.rjw@sisk.pl> <AANLkTim6+4DVX8FgLEcFgq-afjJNouKE9qOe_xzsxFM_@mail.gmail.com>
In-Reply-To: <AANLkTim6+4DVX8FgLEcFgq-afjJNouKE9qOe_xzsxFM_@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2010 10:09 AM, Linus Torvalds wrote:
> On Tue, Aug 17, 2010 at 6:07 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>>
>> It doesn't revert cleanly so appended is the revert patch I used for the
>> verification if this commit is really responsible for the boot failure.
> 
> Hans, Peter? What's the status of this? Should I just take the revert
> from Rafael? Ping?
> 

I have a fix from Hans queued up in x86/urgent and it will be in the
next push of the fixes queue, which I am planning to send you today.

http://git.kernel.org/tip/07a7795ca2e6e66d00b184efb46bd0e23d90d3fe

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

