Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757965Ab2DXWBt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 18:01:49 -0400
Received: from claw.goop.org ([74.207.240.146]:34476 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757282Ab2DXWBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 18:01:48 -0400
Message-ID: <4F9722CA.80403@goop.org>
Date: Tue, 24 Apr 2012 15:01:46 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Ben Dooks <ben-linux@fluff.org>,
        Xen Devel <Xen-devel@lists.xensource.com>,
        Sumit Semwal <sumit.semwal@linaro.org>, Rob Lee <rob.lee@linaro.org>
Subject: Re: linux-next: clean up time
References: <20120402112009.3477dad7deff0f4d87f49b29@canb.auug.org.au> <20120423164859.082b5c53b5d9bd9a524ec864@canb.auug.org.au>
In-Reply-To: <20120423164859.082b5c53b5d9bd9a524ec864@canb.auug.org.au>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2012 11:48 PM, Stephen Rothwell wrote:
> Hi all,
>
> On Mon, 2 Apr 2012 11:20:09 +1000 Stephen Rothwell
<sfr@canb.auug.org.au> wrote:
>>
>> Can people please clean up stuff in their trees that has been merged by
>> their upstream. This is especially useful where the upstream merged (or
>> applied) a slightly different version of their tree.
>
> There is still much cruft in the linux-next included trees ... The
> following trees appear empty (relative to Linus' tree) but cause conflicts:
>
> bjdooks-i2c
> xen
> dma-buf
> cpuidle-cons

Are you pulling from xen.git upstream/xen?  I just updated it to be
current Linus master, so it shouldn't conflict any more.

Thanks,
    J

