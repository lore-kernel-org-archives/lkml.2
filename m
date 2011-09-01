Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384Ab1IAM1s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 08:27:48 -0400
Received: from tuxonice.net ([96.126.116.212]:56632 "EHLO mail.tuxonice.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757191Ab1IAM1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 08:27:47 -0400
X-Greylist: delayed 659 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Sep 2011 08:27:47 EDT
Message-ID: <4E5F77A7.7090200@tuxonice.net>
Date: Thu, 01 Sep 2011 22:16:39 +1000
From: Nigel Cunningham <nigel@tuxonice.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.20) Gecko/20110805 Lightning/1.0b2 Thunderbird/3.1.12
MIME-Version: 1.0
To: Pedro Ribeiro <pedrib@gmail.com>
CC: Kernel development list <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        TuxOnIce-devel <tuxonice-devel@tuxonice.net>
Subject: Re: [TuxOnIce-devel] Thinkpad hotkeys and USB audio not working after
 resume in 3.0.x
References: <CAEDdjHfu71X04JR2Yx8N495bDoJRudch3xbzNAEmUpVxYS+Oww@mail.gmail.com>
In-Reply-To: <CAEDdjHfu71X04JR2Yx8N495bDoJRudch3xbzNAEmUpVxYS+Oww@mail.gmail.com>
X-TagToolbar-Keys: D20110901221639435
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pedro.

On 01/09/11 20:36, Pedro Ribeiro wrote:
> Hi,
> 
> I'm hitting a bug with my thinkpad T400. After resuming from Hibernate,
> the thinkpad hotkeys and my USB audio card do not work at all.
> Suspending to RAM and resuming seem to solve the problem, but after
> another hibernation it comes back again.
> 
> This only happens with TuxOnIce but not with the vanilla kernel.
> 
> Rafael, can you please point out from the top of your head if there was
> any change that could have caused this?

Sorry for my slowness in getting back to you Pedro.

When you invoke swsusp, is it in exactly the same way that TuxOnIce is
invoked? I'm wondering whether modules are unloaded and services stopped
in one scenario that are handled differently in the other.

Regards,

Nigel
-- 
Evolution (n): A hypothetical process whereby improbable
events occur with alarming frequency, order arises from chaos, and
no one is given credit.
