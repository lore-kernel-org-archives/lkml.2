Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339Ab1HBU70 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 16:59:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51897 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755311Ab1HBU7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 16:59:23 -0400
Message-ID: <4E38651C.1030008@zytor.com>
Date: Tue, 02 Aug 2011 13:59:08 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gma500: Fix clashes with DRM updates
References: <20110726161536.4910.21396.stgit@localhost.localdomain> <4E38601F.5090808@zytor.com> <20110802204803.GA14460@kroah.com>
In-Reply-To: <20110802204803.GA14460@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2011 01:48 PM, Greg KH wrote:
> On Tue, Aug 02, 2011 at 01:37:51PM -0700, H. Peter Anvin wrote:
>> On 07/26/2011 09:15 AM, Alan Cox wrote:
>>> From: Alan Cox <alan@linux.intel.com>
>>>
>>> The private object support has migrated from gma500 into the DRM core,
>>> remove our now clashing copy so -next can build.
>>>
>>> Signed-off-by: Alan Cox <alan@linux.intel.com>
>>
>> This patch is needed in Linus' tree, as it is currently causing a build
>> failure for either i386 or x86_64 allyesconfig.
> 
> Ick, it is?  I don't see that here on my builds, what am I doing wrong?
> 
> confused,
> 

No idea, but do a "make allyesconfig" on Linus' tree and you'll see it.

	-hpa

