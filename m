Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927Ab2DSX0g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 19:26:36 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63090 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529Ab2DSX0f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 19:26:35 -0400
MIME-Version: 1.0
In-Reply-To: <4F909B56.60001@zytor.com>
References: <1334794610-5546-1-git-send-email-hpa@zytor.com>
	<20120419092255.GA29542@aftab>
	<20120419092630.GD29542@aftab>
	<4F904541.2030200@zytor.com>
	<CA+55aFwMsm7zVqPjKptm38zJAbJpF=9e51ew7BP6S5YnoJa3ig@mail.gmail.com>
	<20120419173802.GI3221@aftab.osrc.amd.com>
	<4F90527B.7020005@zytor.com>
	<CA+55aFxhY1Ug5esj==Sm=o1Epg+NFnvFs74syqRxbYDbPQJEFA@mail.gmail.com>
	<9ff2e09c-57e4-455e-8614-1b3b17b652f4@email.android.com>
	<4F9072CA.6030903@gmail.com>
	<4F908EA5.4060507@zytor.com>
	<CA+8MBbKz4GNs-mFj5=dCpRe_XLgoKZZz-8GM+FqTMTDBKqJNJw@mail.gmail.com>
	<CA+55aFx8EDb3MOrpky7aBf28=5XQ41ebuunO5aYrnUY1haVzcA@mail.gmail.com>
	<4F909B56.60001@zytor.com>
Date: Thu, 19 Apr 2012 16:26:35 -0700
Message-ID: <CA+8MBbLdq4YYFJXO5HT-=MExO_s-eFkxFigHD0H=Zj5BvHtSVA@mail.gmail.com>
Subject: Re: [PATCH 3/3] x86, extable: Handle early exceptions
From: Tony Luck <tony.luck@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        David Daney <ddaney.cavm@gmail.com>, Borislav Petkov <bp@amd64.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        David Daney <ddaney@caviumnetworks.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2012 at 4:10 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> be better.  That being said, some distros are complaining about the
> amount of time it takes to load modules on boot...

That could be fixed in the installer for the distribution by rebuilding a kernel
with the target set of modules for the system built in.

-Tony
