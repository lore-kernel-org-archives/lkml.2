Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851Ab1D3UUS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 16:20:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51842 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753073Ab1D3UUQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 16:20:16 -0400
MIME-Version: 1.0
In-Reply-To: <G9uL1cldhmL.A.sNF.dWGvNB@chimera>
References: <Xp4OiTz83N.A.O0D.JVGvNB@chimera> <G9uL1cldhmL.A.sNF.dWGvNB@chimera>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 30 Apr 2011 12:51:43 -0700
Message-ID: <BANLkTinZRdGROHZqjLFtr=buEUNwyYhVpQ@mail.gmail.com>
Subject: Re: [Bug #32982] Kernel locks up a few minutes after boot
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Bart Van Assche <bart.vanassche@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think we had all assumed that this was the MD problem that should
have been fixed in rc4 (the symptoms matched), but I don't think we
got any confirmation from Bart on that.

Bart? Does the problem still persist in current -git?

                 Linus

On Sat, Apr 30, 2011 at 12:42 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.38.  Please verify if it still should be listed and let the tracking team
> know (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=32982
> Subject         : Kernel locks up a few minutes after boot
> Submitter       : Bart Van Assche <bart.vanassche@gmail.com>
> Date            : 2011-04-10 19:55 (21 days old)
>
>
>
