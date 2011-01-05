Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845Ab1AEXrv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 18:47:51 -0500
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:57183 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753031Ab1AEXrs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 18:47:48 -0500
MIME-Version: 1.0
In-Reply-To: <20110105211847.GA16229@kroah.com>
References: <1293178543-7556-1-git-send-email-omar.ramirez@ti.com>
	<20110105211847.GA16229@kroah.com>
Date: Wed, 5 Jan 2011 17:47:47 -0600
Message-ID: <AANLkTikWpxq+35pLN_r6B214jcO2Ss2rEv0KA9bcMJFL@mail.gmail.com>
Subject: Re: [GIT PULL] staging: tidspbridge for 2.6.38
From: "Ramirez Luna, Omar" <omar.ramirez@ti.com>
To: Greg KH <greg@kroah.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        Felipe Contreras <felipe.contreras@gmail.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 5, 2011 at 3:18 PM, Greg KH <greg@kroah.com> wrote:
> On Fri, Dec 24, 2010 at 02:15:43AM -0600, Omar Ramirez Luna wrote:
>> Hi Greg,
>>
>> This is the first pull request of changes for tidspbridge driver for 2.6.38,
>> I expect to make another request with at least one bug fix, but in the mean
>> time here it is the content for this one:
>>
>> The following changes since commit 90a8a73c06cc32b609a880d48449d7083327e11a:
>>
>>   Linux 2.6.37-rc7 (2010-12-21 11:26:40 -0800)
>>
>> are available in the git repository at:
>>   git://dev.omapzoom.org/pub/scm/tidspbridge/kernel-dspbridge.git dspbridge
>
> Ick, no.  Why did you base this on -rc7?  My staging-next branch is
> based on -rc5 at the moment, and I really see no need to merge the rest
> of them into the tree for no good reason at all.

wrongly though staging-next would be at rc7+ at the time you could
take a look to the patches

> Also, as you did send this before the merge window closed, but during
> the holidays, I couldn't get to it.  But in looking at this, it's going
> to have to wait for the next window, sorry, it's just too big, and too
> late.  You weren't expecting me to be working on kernel stuff during my
> holiday break, were you?

No I wasn't :)

> So, feel free to redo this against 2.6.38-rc1 when that comes out.

No problem then, but could you consider a 2nd pull with a compilation
fix (which will be introduced in 2.6.38, right now present in
linux-next), and a bug fix.

I'll send it and wait for any comments.

Regards,

Omar
