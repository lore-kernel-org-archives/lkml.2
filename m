Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843Ab2CMFao (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 01:30:44 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35644 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754640Ab2CMFam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 01:30:42 -0400
Date: Mon, 12 Mar 2012 22:30:35 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-input@vger.kernel.org, sameo@linux.intel.com,
        broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, myungjoo.ham@samsung.com
Subject: Re: [PATCH v2 0/2] input: add MAX8997-haptic driver
Message-ID: <20120313053035.GB9449@core.coreip.homeip.net>
References: <4F571629.8010203@samsung.com>
 <20120307082900.GA20493@core.coreip.homeip.net>
 <4F5DB45C.4050101@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F5DB45C.4050101@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 05:31:24PM +0900, Chanwoo Choi wrote:
> Hi Dmitry,
> 
> On 03/07/2012 05:29 PM, Dmitry Torokhov wrote:
> > Hi Chanwoo,
> > 
> > 
> > On Wed, Mar 07, 2012 at 05:02:49PM +0900, Chanwoo Choi wrote:
> >> MAX8997 has several features in a single chip,
> >> This patchset supports unimplemented haptic driver of MAX8997.
> >>
> >> v2
> >> - code clean and remove unnecessary code according to comment of Dmitry
> >> Torokhov
> > 
> > Could you please tell me if the version of the patch I sent to you
> > worked or not?
> 
> It isn't worked because it use the mutex lock in irq handler stack.
> so, I resend v3 patch of max8997-haptic driver after modifying it.

Hmm, my patch did not add taking mutex in irq context, I presume you are
talking about max8997->iolock that is taken in max8997_write_reg... OK,
I see...

-- 
Dmitry
