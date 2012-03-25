Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833Ab2CYSxx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 14:53:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48077 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756779Ab2CYSxv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 14:53:51 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdXcJCdt+X53zrSUbpvFxL2WzuQH6MWByFvQ5E0UT2LHYg@mail.gmail.com>
References: <1332323515-7314-1-git-send-email-geert@linux-m68k.org>
	<1332323515-7314-5-git-send-email-geert@linux-m68k.org>
	<4F6E950E.30809@gmail.com>
	<CAMuHMdXcJCdt+X53zrSUbpvFxL2WzuQH6MWByFvQ5E0UT2LHYg@mail.gmail.com>
Date: Mon, 26 Mar 2012 07:53:50 +1300
Message-ID: <CAOmrzk+m2+GKOu+1nOJ2E1Aogx3Lj7vbUDHG5azK+A492MkDOw@mail.gmail.com>
Subject: Re: [PATCH 05/11] m68k/atari: Add missing platform check before
 registering platform devices
From: Michael Schmitz <schmitzmic@googlemail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,


>> How about this instead - probe for the EtherNAT config register, and
>> register devices only if found?
>
> That's even better, but logically, it's an extra change on top, so I'd like
> to keep it separate.

OK, I'll resend as soon as I've pulled your latest changes.

>> +    if (MACH_IS_ATARI) {
>
> I prefer the "if (!MACH_IS_ATARI) return -ENODEV;" at the top, as it
>  - means less code to change if more platform devices are added,
>  - means less source code to keep on your mental stack when reading the code,
>  - decreases indentation for the rest of the function.

OK; do you want the tests and platform calls conditional on config
options (we only need to have the platform data available if there's a
driver or module built to use it)?

Cheers,

  Michael
