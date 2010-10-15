Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809Ab0JOUZo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 16:25:44 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59620 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826Ab0JOUZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 16:25:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=EM1vSRV8N3s0oEpAN1YWRY1f10lzYpoRyCq2n1JIek3olLmHims0lrxFRL5yT0mGJJ
         kz6++PKAwwz7GWlJqzSQ7LU08rt3kWB4rf3NbnnLL4Kim877OajaVVyDkdoyVpck5ro0
         hTaS+7/IDjbwOiK4d+ufviD6kegEDhReMZIkA=
MIME-Version: 1.0
In-Reply-To: <20101015194255.GA12981@n2100.arm.linux.org.uk>
References: <1287152120-7201-1-git-send-email-felipe.contreras@gmail.com>
	<1287153021.27165.6.camel@e102109-lin.cambridge.arm.com>
	<20101015194255.GA12981@n2100.arm.linux.org.uk>
Date: Fri, 15 Oct 2010 23:00:40 +0300
Message-ID: <AANLkTinmAy13niqRKrray1Gk4hkr19tA2gWwYbfnFoh7@mail.gmail.com>
Subject: Re: [PATCH .36-rc8] arm: mm: allow, but warn, when issuing ioremap()
 on RAM
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        linux-main <linux-kernel@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Richard Woodruff <r-woodruff2@ti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 15, 2010 at 10:42 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> As soon as the first ARM merge hits during the merge window, I'll be
> restoring the 'always fail' behaviour.

Ok, are you going to merge also your patch to use memblock for the
initialization? Many drivers could certainly use that to fix the
issue.

-- 
Felipe Contreras
