Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798Ab0IKAfA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 20:35:00 -0400
Received: from straum.hexapodia.org ([207.7.131.186]:48330 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755337Ab0IKAe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 20:34:59 -0400
Date: Fri, 10 Sep 2010 17:34:59 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: Norbert Preining <preining@logic.at>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net
Subject: Re: after closing the lid and reopening it the screen remains blank
Message-ID: <20100911003459.GW23291@hexapodia.org>
References: <20100909224117.GA30000@gamma.logic.tuwien.ac.at> <20100910184751.GA17794@hexapodia.org> <20100910234448.GB9848@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100910234448.GB9848@gamma.logic.tuwien.ac.at>
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 11, 2010 at 08:44:48AM +0900, Norbert Preining wrote:
> On Fr, 10 Sep 2010, Andy Isaacson wrote:
> > FWIW, 2.6.36-rc3-00396-gbe6200a suspend-to-ram works for me on GM45
> 
> I never said that it has anything to do with suspend to ram.

Ah, sorry for misunderstanding.  My GM45 system is configured to
automatically S2R on lid close so I tend to conflate the two...

> In fact, suspend to ram works perfectly without any problems. I only
> reboot after I installed a new kernel ...
> 
> I will try some older kernels and see if it is a kernel or userspace
> issue.

Do try the current tip and/or describe which post-rc3 kernel fails for
you, just to verify.  Also, is there anything in Xorg.0.log from when it
fails to restore the video?

Thanks for reporting the regression, it'll be good to get it fixed ASAP.

-andy
