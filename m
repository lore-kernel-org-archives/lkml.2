Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933047Ab2C2OFf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 10:05:35 -0400
Received: from magic.merlins.org ([209.81.13.136]:56091 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758756Ab2C2OF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 10:05:29 -0400
Date: Thu, 29 Mar 2012 07:05:26 -0700
From: Marc MERLIN <marc@merlins.org>
To: David Miller <davem@davemloft.net>,
        James Courtier-Dutton <james.dutton@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 3.2.8/amd64 full interrupt hangs and deadlocks under big network copies (page allocation failure)
Message-ID: <20120329140526.GG24933@merlins.org>
References: <20120311183244.GA14001@merlins.org> <CAAMvbhHGeZMrTcc6DiOAtk7Vg3Qu1KE7bs8D3E3N-sCtRPzmwg@mail.gmail.com> <20120311183244.GA14001@merlins.org> <20120329053111.GD24933@merlins.org> <20120329.024910.1984119977666436533.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAMvbhHGeZMrTcc6DiOAtk7Vg3Qu1KE7bs8D3E3N-sCtRPzmwg@mail.gmail.com> <20120329.024910.1984119977666436533.davem@davemloft.net>
X-Sysadmin: BOFH
X-URL: http://marc.merlins.org/
X-Operating-System: Proudly running Linux 3.1.5-core2-volpreempt-noide-hm64-20111218/Debian squeeze/sid
X-Mailer: Some Outlooks can't quote properly without this header
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: marc@merlins.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 02:49:10AM -0400, David Miller wrote:
> From: Marc MERLIN <marc@merlins.org>
> Date: Wed, 28 Mar 2012 22:31:11 -0700
>
> > This is a pretty bad failure. Someone please tell me there is
> > something I can do to work around the problem, and get the
> > underlying problem fixed.
>
> First step would be to report this to the proper mailing list,
> most networking and wireless developers do not read linux-kernel.
>
> I'd start with linux-wireless@vger.kernel.org and netdev@vger.kernel.org

On Thu, Mar 29, 2012 at 09:36:02AM +0100, James Courtier-Dutton wrote:
> That looks like a network card problem. Probably a hardware bug. Try a
> different network card if you can.

Thanks both for the answer. I don't think it's a network hardware
problem since it happens with both e1000e wired and iwlwifi wireless.

I wasn't quite sure if it was a memory allocation problem that caused the
hangs, but you're right that it's most likely a networking issue regardless
of the fact that it happens on both wired and wireless.

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/
