Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759990Ab0JFWNP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 18:13:15 -0400
Received: from trinity.fluff.org ([89.16.178.74]:60923 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759976Ab0JFWNO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 18:13:14 -0400
Date: Wed, 6 Oct 2010 23:12:58 +0100
From: Ben Dooks <ben-i2c@fluff.org>
To: Kyungmin Park <kmpark@infradead.org>
Cc: Ben Dooks <ben-i2c@fluff.org>, Jean Delvare <khali@linux-fr.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux I2C <linux-i2c@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] i2c fixes for 2.6.36
Message-ID: <20101006221258.GV21564@trinity.fluff.org>
References: <20101001140619.28d96040@endymion.delvare> <AANLkTi=aKWP3_KhD88ebGB04xAM9Pc7eqw1LBr2EJNS_@mail.gmail.com> <20101001140918.GU21564@trinity.fluff.org> <AANLkTikvXe5ZHCqqtfkAWu=78HWe0BD=suDMGETwd+hC@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikvXe5ZHCqqtfkAWu=78HWe0BD=suDMGETwd+hC@mail.gmail.com>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 01, 2010 at 11:18:49PM +0900, Kyungmin Park wrote:
> On Fri, Oct 1, 2010 at 11:09 PM, Ben Dooks <ben-i2c@fluff.org> wrote:
> > On Fri, Oct 01, 2010 at 10:38:46PM +0900, Kyungmin Park wrote:
> >> Hi Jean,
> >>
> >> Even though it's not yet acked from Ben. It should be fixed for
> >> correct operation.
> >> Without this patch, some I2C device doesn't work correctly.
> >> http://www.spinics.net/lists/linux-i2c/msg04016.html
> >
> > It was in my last pull request to Linus.
> Thanks Ben,
> 
> To Ben,
> Do you have a plan to use notification mail or  confirm mail to ensure
> these patches are merged or not.
> I think it's helpful to your maintained subsystem participants. e.g,
> samsung soc, sdhci-s3c, i2c and so on.

I do try and send confirmation emails with every patch, but it currently
is a manual process.

-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

