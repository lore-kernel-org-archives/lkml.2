Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781Ab2FPFu3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 01:50:29 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:60432 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129Ab2FPFuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 01:50:18 -0400
Date: Sat, 16 Jun 2012 07:50:09 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Dave Jones <davej@redhat.com>, John Stultz <john.stultz@linaro.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Fedora Kernel Team <kernel-team@fedoraproject.org>
Subject: Re: missing leap second patches in stable.
Message-ID: <20120616055007.GA5808@netboy.at.omicron.at>
References: <20120615152007.GA11793@redhat.com>
 <4FDB8382.8090501@linaro.org>
 <20120615190958.GA9864@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120615190958.GA9864@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 03:09:59PM -0400, Dave Jones wrote:
> On Fri, Jun 15, 2012 at 11:48:34AM -0700, John Stultz wrote:
>  > On 06/15/2012 08:20 AM, Dave Jones wrote:
>  > > Should these be in -stable ? Looks like all the other recent changes
>  > > in that area are present.  With the leap second just two weeks away,
>  > > it seems like they should be.
>  > >
>  > > Looks like 6b43ae8a619d17c4935c3320d2ef9e92bdeed05d is in 3.4-stable,
>  > > (haven't checked earlier -stable trees).
>  > 
>  > So the second patch has been sent out for stable review as of yesterday. 
>  > So it should be on its way, but you're right that I forgot to CC stable 
>  > on the first TAI offset fix.
>  > 
>  > I'll generate the patch and send it to Greg.  Thanks for the close 
>  > review here!
> 
> fwiw, I did a test on 3.5rc2 yesterday where I forced a fake leap second at midnight.
> Nothing untoward happened, unlike the previous ones :-)

Out of curiosity, how do you test that? Do you have any programs
specifically for testing the leap second issue?

Thanks,
Richard


