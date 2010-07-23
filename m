Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751781Ab0GWS1n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 14:27:43 -0400
Received: from thunk.org ([69.25.196.29]:60044 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780Ab0GWS1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 14:27:41 -0400
Date: Fri, 23 Jul 2010 14:27:38 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Dave Airlie <airlied@redhat.com>
Subject: Re: [Bug #16265] Why is kslowd accumulating so much CPU time?
Message-ID: <20100723182738.GA1256@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Maciej Rutecki <maciej.rutecki@gmail.com>,
	Dave Airlie <airlied@redhat.com>
References: <Lupw7pePXBO.A.fZH.G2XSMB@chimera>
 <tneGvaw1wLL.A.21B.E4XSMB@chimera>
 <20100723144143.GA14650@elliptictech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100723144143.GA14650@elliptictech.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 23, 2010 at 10:41:43AM -0400, Nick Bowler wrote:
> 
> I actually haven't been able to reproduce with kernels since a couple
> weeks ago (still reproducible if I go back to 2.6.35-rc3, though).
> Seems to be fixed somehow, can anyone else confirm?

I'll try to reproduce it over the weekend.

							- Ted
