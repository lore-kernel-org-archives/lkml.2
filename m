Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757078Ab1I3HlS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 03:41:18 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:43860 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755286Ab1I3HlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 03:41:17 -0400
Subject: Re: [PATCH v3 10/10] x86, efi: EFI boot stub support
From: Matt Fleming <matt@console-pimps.org>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Andi Kleen <andi@firstfloor.org>,
        Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        MikeWaychiso@bitmath.org
In-Reply-To: <20110929101418.GA2215@polaris.bitmath.org>
References: <1315838094-2307-11-git-send-email-matt@console-pimps.org>
	 <1316607036-9235-1-git-send-email-matt@console-pimps.org>
	 <20110929101418.GA2215@polaris.bitmath.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 Sep 2011 08:41:05 +0100
Message-ID: <1317368465.3375.6.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-29 at 12:14 +0200, Henrik Rydberg wrote:
> Using this version 3 of the patch, and a builtin commandline, I am
> able to boot a MacBookAir3,1 directly into a blessed bzImage. The
> screen comes up correctly.
> 
> Tested-by: Henrik Rydberg <rydberg@euromail.se>

Great! Thanks for testing it out.

> As a side note, resume from suspend seems to leave the screen blank.

Hmm.. interesting. Presumably this only happens with these patches
applied? i.e. if you remove the patches you don't see a blank screen on
resume? I'll see if I can reproduce this on my macbook.

-- 
Matt Fleming, Intel Open Source Technology Center

