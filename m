Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750976Ab1ADWE0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 17:04:26 -0500
Received: from gherkin.frus.com ([192.158.254.49]:35364 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699Ab1ADWEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 17:04:24 -0500
Date: Tue, 4 Jan 2011 16:04:21 -0600
From: Bob Tracy <rct@gherkin.frus.com>
To: Matt Turner <mattst88@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org,
        mcree@orcon.net.nz
Subject: Re: [BUG] implicit declaration of kfree/kzalloc in i2c-i801.c on Alpha
Message-ID: <20110104220421.GA29096@gherkin.frus.com>
References: <20110104061821.GA25886@gherkin.frus.com> <AANLkTikOsULOVq01CEiPuoK4-sFTk+KWJiLY0wnzUZ17@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikOsULOVq01CEiPuoK4-sFTk+KWJiLY0wnzUZ17@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 04, 2011 at 02:37:00PM -0500, Matt Turner wrote:
> On Tue, Jan 4, 2011 at 1:18 AM, Bob Tracy <rct@gherkin.frus.com> wrote:
> > Another 2.6.37-rc8 build failure on alpha:
> >
> > (...)
> > ?CC [M] ?drivers/i2c/busses/i2c-i801.o
> > drivers/i2c/busses/i2c-i801.c: In function 'i801_probe':
> > drivers/i2c/busses/i2c-i801.c:737: error: implicit declaration of function 'kzalloc'
> > drivers/i2c/busses/i2c-i801.c:737: warning: assignment makes pointer from integer without a cast
> > drivers/i2c/busses/i2c-i801.c:855: error: implicit declaration of function 'kfree'
> > make[3]: *** [drivers/i2c/busses/i2c-i801.o] Error 1
> > make[2]: *** [drivers/i2c/busses] Error 2
> > make[1]: *** [drivers/i2c] Error 2
> > make: *** [drivers] Error 2
> 
> Is this specific to alpha? I wonder why we don't see this on other platforms?

I'll start the Intel build this evening to check, but I'd be willing to
bet it's Alpha-specific (only because no one else has hollered).

--Bob
