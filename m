Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756972Ab2BWUyN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 15:54:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57491 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756657Ab2BWUyM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 15:54:12 -0500
Message-ID: <4F46A6EC.8050804@zytor.com>
Date: Thu, 23 Feb 2012 12:51:56 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>, stable@vger.kernel.org,
        Raphael Prevost <raphael@buro.asia>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] i387: stable kernel backport
References: <alpine.LFD.2.02.1202221252060.20522@i5.linux-foundation.org> <20120222211928.GA4448@kroah.com> <CA+55aFz0pOO6j9s3Gs2UJLM4zm8SuPgi5iUiVAaPCp9Xh2Pvjw@mail.gmail.com> <20120222213253.GA25150@kroah.com> <20120223200905.GA5475@kroah.com> <4F46A1C4.90506@zytor.com> <20120223204832.GA30322@kroah.com>
In-Reply-To: <20120223204832.GA30322@kroah.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2012 12:48 PM, Greg Kroah-Hartman wrote:
> On Thu, Feb 23, 2012 at 12:29:56PM -0800, H. Peter Anvin wrote:
>> On 02/23/2012 12:09 PM, Greg Kroah-Hartman wrote:
>>>
>>> I've applied this now to the 3.0 and 3.2-stable trees.  It looks like it
>>> would work on the 2.6.32-stable tree, but it needs some tweaks, and as I
>>> can't really test this, and the .32-stable tree is probably not going to
>>> have problems in this area, I'll let someone else generate those patches
>>> and test them if they feel it is needed there.
>>>
>>
>> It doesn't seem to appear in the stable git tree... anywhere I can get
>> your tree so I can test these out?
> 
> They are in the stable-queue git tree at:
> 	/pub/scm/linux/kernel/git/stable/stable-queue.git
> on git.kernel.org
> 
> Testing them out would be great, if you want, I can knock up a git tree
> with just these patches in it on 3.2.7 or anything else you need to test
> with, if that makes it easier for you.
> 

That would be awesome.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

