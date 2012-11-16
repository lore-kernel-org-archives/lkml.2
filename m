Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139Ab2KPQyd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 11:54:33 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:62239 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716Ab2KPQyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 11:54:31 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Michal Simek <michal.simek@xilinx.com>
Subject: Re: [GIT PULL] arm-soc: Xilinx zynq changes for v3.8
Date: Fri, 16 Nov 2012 16:54:23 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: arm@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "linux-arm" <linux-arm-kernel@lists.infradead.org>,
        Olof Johansson <olof@lixom.net>,
        Nick Bowler <nbowler@elliptictech.com>,
        Josh Cartwright <josh.cartwright@ni.com>,
        John Linn <John.Linn@xilinx.com>
References: <CAHTX3dLdGie9gtxbPq_gb8BLao7YYohqQWZFg3LzyNHxu=imdg@mail.gmail.com> <CAHTX3dLijLK45ddZQVYHcrs6QQbmdRmQbPmTKada9nXx3ZAe3w@mail.gmail.com>
In-Reply-To: <CAHTX3dLijLK45ddZQVYHcrs6QQbmdRmQbPmTKada9nXx3ZAe3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201211161654.23470.arnd@arndb.de>
X-Provags-ID: V02:K0:Jgh6fex7fNAtE/REPQlfj/ghkMGJWx68281Q3B28KF4
 8Qi/Ihh/F+qFkTHwo6jKSgVKN7b5c3UaaO5QDjbv089H7Q6GIc
 2phmnGu8nwt2u51v+GAuLVuUyJueoO43s6/H4f/BJcVq8iC/7V
 73ZQJfniPoW6Y6mEls5m6+STJdFa7Dr7f/zzQU48FV8VGtVvYZ
 FQRxepnatcVpjf4+jvWS0cTMfY5ySl7HAUP/FYNRWaX+fDpevV
 Astfo5c7N9XOl4C51PKw//Gp9Y8TTv4cMLpEVc07nT+1w1AI58
 HMj5CvJV5SRQS5Zm/mAqaC5gUL8Ce09YCwXUBuWm1lM6oZODg9
 qrrDNPMFgVUQqiA9JvaE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 November 2012, Michal Simek wrote:
> I have 7 new follow up patches for zynq. They are based on previous patches
> (arm-soc zynq/cleanup branch).
> The branch is still based on rc3 but I have also tried to merged it
> with the v3.7-rc5 and there is no issue.
> 
> It should be the last pull request for v3.8.
> 

Pulled into next/dt, thanks!

This was a small set of patches and you're new to the job, so there is
no problem with what you sent me, but I have a few comments for the
future:

* Please provide a description of the series that I can put into the
merge changeset, either in the introductory mail or (better) into
the signed tag that you send (git tag -s). Have a look at how
Tony Lindgren does this, he writes the best descriptions.

* I've used the next/dt branch, since that is what most of the patches
from this series best fit in. However, some of the patches would
have made more sense in a different branch (clock, cleanup, ...).
When you have things that are logically separate, just send separate
pull requests. This takes some practice to get the dependencies
right, so please ask if you are not sure how to do it.

* It seems the zynq multiplatform changes didn't make it for 3.8. I
hope you can do this for 3.9, as this should not be too hard.

	Arnd
