Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347Ab2ILLyi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 07:54:38 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:63657 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219Ab2ILLyh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 07:54:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jon Masters <jonathan@jonmasters.org>
Subject: Re: [PATCH v3 00/31] AArch64 Linux kernel port
Date: Wed, 12 Sep 2012 11:54:20 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-arch@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com> <504E4C0E.9030402@jonmasters.org>
In-Reply-To: <504E4C0E.9030402@jonmasters.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 8BIT
Message-Id: <201209121154.20474.arnd@arndb.de>
X-Provags-ID: V02:K0:iPbhfuc7ikVEH6u1p5+pjJggwX7fyMJgxE59Xede6y/
 wHX0MHCRi728/7kEQKA1cecSZ+w84s/qnaGWbTxjbYEGRRPjqP
 DfnP01kvc9KIRwwKPulJKcDq45uGfk6yQ9GQvoNzWnlydws9rm
 uuaMkc2P81zszXyASfds1842TM03yupWbwGZWGH/gr1oXQHA7G
 40vZVTMkYssyRDcnjAxrzGTnpa52iP/Z+HFFLiW1IOhgnnoOD1
 Bl8jmyvlhhYAAeMoy4tJNotHzq4tk31FXvISrxAq39bj6NTCnU
 a58RN4PM0u6pY0X/gKIe/ZxFYIVw8Z+3htuXn0dTk7krx23yoq
 x/s/hMm31MOLWEFvpu+A=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 September 2012, Jon Masters wrote:
> On 09/07/2012 12:26 PM, Catalin Marinas wrote:
> > This is the 3rd version of patches implementing Linux kernel support for
> > the 64-bit ARM architecture.
> <snip>
> 
> > ...but the main goal was to freeze the user ABI.
> 
> Is the consensus now that we're good from an ABI viewpoint?
> 

>From my point of view, no more changes are needed. I would not give any
guarantees until we have a first kernel release including this code, but
I think we can agree that we would consult you about ABI changes if they
seem necessary before then.

If you start (re)building the Fedora packages based on these kernel
headers, the changes are pretty good that this will keep working.

	Arnd
