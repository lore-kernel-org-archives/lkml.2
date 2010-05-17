Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584Ab0EQDAQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 23:00:16 -0400
Received: from lo.gmane.org ([80.91.229.12]:44495 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752289Ab0EQDAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 23:00:14 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
connect(): No such file or directory
From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Linux 2.6.34
Date: Sun, 16 May 2010 23:00:03 -0400
Message-ID: <hsqbfk$104$1@dough.gmane.org>
References: <alpine.LFD.2.00.1005161430100.4195@i5.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: pool-68-236-145-113.alb.east.verizon.net
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100402 Fedora/2.0.4-1.fc13 NOT Firefox/3.5.3 SeaMonkey/2.0.4
In-Reply-To: <alpine.LFD.2.00.1005161430100.4195@i5.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
>
> Nothing very interesting here, which is just how I like it. Various random
> fixes all over, nothing really stands out. Pretty much all of it is one-
> or few-liners, I think the biggest patch in the last week was fixing some
> semantics for the new SR-IOV VF netlink interface. And even that wasn't
> a _big_ patch by any means.
>
> So 2.6.34 is out, and the merge window is thus officially open. As usual,
> I probably won't do any real pulls for a day or two, in the (probably
> futile) hope that we'll have more people running plain 2.6.34 for a while.
> But you can certainly start sending me pull requests.
>
> Go forth and test,
>
I hate to be the bearer of bad news, but the ibmcam stopped working. And 
since my test machine is a security cam server, that's not good.

The good news is that it was originally reported as a bug in Fedora, 
because I saw it first in one of their pre-beta upgrades. There is a 
bunch of related information at
   https://bugzilla.redhat.com/show_bug.cgi?id=588900
which hopefully will be useful.

Built with the Fedora 2.6.33.3-85.fc13.x86_64 config, plus make oldconfig.

Otherwise looks functional, ran light testing on it, but really had to 
fall back.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

