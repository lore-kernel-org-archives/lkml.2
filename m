Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125Ab1CZLZK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 07:25:10 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:56298 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685Ab1CZLZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 07:25:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <gregkh@suse.de>
Subject: Re: [RFC PATCHv2 1/4] drivers/otp: add initial support for OTP memory
Date: Sat, 26 Mar 2011 12:25:03 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38+; KDE/4.5.1; x86_64; ; )
Cc: Jamie Iles <jamie@jamieiles.com>, linux-kernel@vger.kernel.org,
        vapier@gentoo.org
References: <1300980071-24645-1-git-send-email-jamie@jamieiles.com> <201103252301.56718.arnd@arndb.de> <20110325232847.GA5551@suse.de>
In-Reply-To: <20110325232847.GA5551@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103261225.03504.arnd@arndb.de>
X-Provags-ID: V02:K0:m8mlENsvl27yxhv2/EeWKssTeU36F96FRe+hoqNuR/g
 Hg/+2WqKAJdS2a3JDiiFJdy6rAK3ANPOWvmBLrxYeEXEZGFSY+
 LJ857bRjS/neNJxIX6HEF8gLNnMcirBR15PbrAowHcn/W6c30u
 331wAxTwtlTdv9C1chk2uKfyR2fOLclLaIMBPTShWsbLK9xnzQ
 UP6p6rHLrRCTeK4cMZwoQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 26 March 2011 00:28:47 Greg KH wrote:

> Yes, that is how it used to be, but then it turns out that both of them
> are really just "subsystems" as far as it all goes.  They are just ways
> that devices are bound to drivers in a logical manner.  We have patches
> floating around that get rid of both busses and classes to merge them
> together, which is the end goal here.  I know Kay has posted detailed
> reasons for why this all is on lkml in the past, and had working code
> about 5 years ago, it's just been slow going...

How will that work? I suppose we can't really change the directory
structure anyway, so to users it will still look like it does today,
even if the kernel just uses the same code for bus and class internally.
 
> So we recommend all new subsystems use the bus code, it's simple and
> works well.

I'm not worried about the code at all, just how it shows up in
sysfs, which is rather confusing when things become a bus that
are not really buses by any stretch. Obviously there are grey
areas and corner cases where a bus makes as much sense as a class,
but I think this one is not such a case.

	Arnd
