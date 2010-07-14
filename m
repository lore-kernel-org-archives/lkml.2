Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495Ab0GNJNZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 05:13:25 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61969 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190Ab0GNJNX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 05:13:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Ab3MyQntFFjOKFgr+woUTN9K0hLYvVnV9IEzsWNNvMoPFd5+5cW5WqPlV7ecLF4cfQ
         ah4kAndyL0GeTpW7CETQUy+i3+WgKV0x9rF8O4XqJ3vQ3xtKbRnEEHSCxVFV5ylHQjb4
         LC4s+gxyQ4YgfkyoZws/rLYsj96XqsOH1MgGg=
MIME-Version: 1.0
In-Reply-To: <201007121634.04427.davidb@codeaurora.org>
References: <alpine.LFD.2.00.1006030725420.8175@i5.linux-foundation.org>
	<201007121605.32462.davidb@codeaurora.org>
	<AANLkTimho3rcoCZZ2PlC3B3KIZZhsEiTnTk-__n1q_Dy@mail.gmail.com>
	<201007121634.04427.davidb@codeaurora.org>
Date: Wed, 14 Jul 2010 12:13:07 +0300
Message-ID: <AANLkTimttp-YgYADPU5scbcSeb-7lb5d7Cf-_g_-0uJ7@mail.gmail.com>
Subject: Re: ARM defconfig files
From: Felipe Contreras <felipe.contreras@gmail.com>
To: David Brown <davidb@codeaurora.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Daniel Walker <dwalker@codeaurora.org>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Eric Miao <eric.miao@canonical.com>, linux-omap@vger.kernel.org,
        Nicolas Pitre <nico@fluxnic.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 13, 2010 at 2:34 AM, David Brown <davidb@codeaurora.org> wrote:
> It seems a bit brute force, probably not something I can make part of
> our regular build process, but I can definitely run it before sending
> patches out.
>
> I wonder if there's a more efficient way of doing it that doesn't
> involve invoking make for each line of the file.  It at least
> shouldn't be necessary to actually build the kernel each time.

Yes, I think there's a more efficient way to do it, but it would
require the SAT resolver, or something like that.

-- 
Felipe Contreras
