Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751174Ab1LKHyU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 02:54:20 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37488 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab1LKHyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 02:54:19 -0500
Message-ID: <1323590203.31951.2.camel@nisroch>
Subject: Re: DRM nouveau crash with 3.2.0-rc5
From: Ben Skeggs <skeggsb@gmail.com>
Reply-To: skeggsb@gmail.com
To: "Berck E. Nash" <flyboy@gmail.com>
Cc: Dave Airlie <airlied@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sun, 11 Dec 2011 17:56:43 +1000
In-Reply-To: <4EE42ADA.5000406@gmail.com>
References: <4EE2E9BB.8060801@gmail.com>
		<CAPM=9tzVxGbsE4+EgTd0apvGBCUcvtnjSH-ydbr-MOVSTf1QaQ@mail.gmail.com>
	 <CACAvsv6g+qz+-ja+4Qfinz04rr0EAyxwxQpFyfcE1fAtqQyuEA@mail.gmail.com>
	 <4EE42ADA.5000406@gmail.com>
Organization: 
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-12-10 at 21:00 -0700, Berck E. Nash wrote:
> On 12/10/2011 08:54 PM, Ben Skeggs wrote:
> > Is this reproducible in any way, or a once off occurance?
> > 
> > It's hard to know if it's a regression or some random bug that's existed
> > forever.
> 
> It only happened once, but nothing like it has ever happened with 3.1,
> and after it happened, I've reverted back to using 3.1.  And it
> shouldn't happen.  I suppose I can see if I can make it happen again...
Of course it shouldn't happen :)  But, minus me being able to reproduce
this somehow (my own machine is stable still) the only way there's any
hope of fixing it is tracking it down to what broken it.

If you can manage to reproduce it, hopefully in some reliable way, it'll
be a huge help.

Thanks,
Ben.


