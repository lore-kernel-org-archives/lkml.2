Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462Ab0F0PFZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 11:05:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44057 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755412Ab0F0PFY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 11:05:24 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1006270710210.7802@i5.linux-foundation.org>
References: <20100614145659.GA2594@elliptictech.com>
	<alpine.LFD.2.00.1006270710210.7802@i5.linux-foundation.org>
Date: Sun, 27 Jun 2010 08:05:18 -0700
Message-ID: <AANLkTilDmY1DDDFlASWM2BnECgVvhszWVRuvXEY4Ty_6@mail.gmail.com>
Subject: Re: [regression, bisected] SysRq commands trigger without holding 
	sysrq.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 27, 2010 at 7:12 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Mon, 14 Jun 2010, Nick Bowler wrote:
>>
>> 97f5f0cd8cd0a05449cbb77d1e6f02e026875802 is the first bad commit
>
> Dmitry? I didn't see any follow-ups on this issue, should I just do the
> revert, or is there some better fix?
>
> There's another report about this from Éric Piel.

Ahh. Never mind. It should be fixed by commit f5dec51172b8 ("Input:
sysrq - fix "stuck" SysRq mode") that was in your pull request that I
already had in my queue. I just hadn't gone through all my mail yet.

                               Linus
