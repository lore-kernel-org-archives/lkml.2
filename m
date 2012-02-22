Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042Ab2BVWfI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 17:35:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52869 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013Ab2BVWfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 17:35:07 -0500
Message-ID: <4F456D8F.1080801@zytor.com>
Date: Wed, 22 Feb 2012 14:34:55 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Raphael Prevost <raphael@buro.asia>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] i387: stable kernel backport
References: <alpine.LFD.2.02.1202221252060.20522@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.02.1202221252060.20522@i5.linux-foundation.org>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2012 12:54 PM, Linus Torvalds wrote:
> 
> This is a reasonably minimal backport of the i387 state save/restore bug.
> 
> A few of the commits are just minimal "make it easier to backport" commits 
> that don't necessarily fix anything on their own.  And a few of the others 
> are combinations of what is two commits in the development tree, because 
> it turned out to be easier and cleaner that way.
> 
> The last one is the one that fixes the x86-32 bug, but the preemption 
> fixes are real fixes too, although they are probably not something that 
> anybody has necessarily ever hit in reality because the race window is so 
> small.  Even so, if the fix itself isn't that important, the "make it 
> easier to backport the main one" would still be a big argument for it.
> 
> I *really* hope that the people who could reproduce this bug will test the 
> back-port series too, since I never actually saw the bug personally to 
> begin with. And again, big thanks to Raphael who helped pinpoint and debug 
> this.
> 

Okay, this patchset does *NOT* work.  It fails immediately on my system.
 I hadn't ever seen it fail so fast.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

