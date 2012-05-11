Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932400Ab2EKC6O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 22:58:14 -0400
Received: from mail.windriver.com ([147.11.1.11]:48008 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932182Ab2EKC6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 22:58:12 -0400
Date: Thu, 10 May 2012 22:58:06 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Sasha Levin <levinsasha928@gmail.com>
CC: <dmitry.torokhov@gmail.com>, <peter.ujfalusi@ti.com>,
        <broonie@opensource.wolfsonicro.com>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] TWL6040: fix build error
Message-ID: <20120511025806.GB24512@windriver.com>
References: <1336675473-24774-1-git-send-email-levinsasha928@gmail.com>
 <CAP=VYLqwAO8x4aWw7_pH1LH_SPO9Td2ec9oOmKPL-_5LOEQw3g@mail.gmail.com>
 <CA+1xoqf+Fjt=vMxnFz37t+mH5MBfc7iTZ0OF2fQdryyWk5TSKA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+1xoqf+Fjt=vMxnFz37t+mH5MBfc7iTZ0OF2fQdryyWk5TSKA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Re: [PATCH] TWL6040: fix build error] On 11/05/2012 (Fri 04:50) Sasha Levin wrote:

> On Fri, May 11, 2012 at 12:49 AM, Paul Gortmaker
> <paul.gortmaker@windriver.com> wrote:
> > On Thu, May 10, 2012 at 2:44 PM, Sasha Levin <levinsasha928@gmail.com> wrote:
> >> Fixes build error due to missing of_property_read_u32.
> >
> > Yes, I saw the same on x86-64 allyesconfig -- which means that in addition to
> > this missing header, it needs to have a Kconfig dependency that limits
> > it to just being enabled on the platforms where it physically is possible to
> > have the hardware.  I'm guessing limiting to ARM would be a good start?
> 
> I'm not sure how the actual hardware looks or even what it does, i
> just wanted to make sure that it doesn't break my x86 build. Which is
> why I'd rather not modify anything further than what I did in this
> patch.

Of course -- I was in the same boat.  I wasn't expecting you in
particular to add the Kconfig dependency, but rather instead I was
hoping someone who knows the platform details would make a proper one.

Paul.
