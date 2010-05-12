Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152Ab0ELNEz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 09:04:55 -0400
Received: from mx3.sophos.com ([74.202.89.160]:33588 "EHLO mx3.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750766Ab0ELNEy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 09:04:54 -0400
From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Organization: Sophos Plc
To: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: 2.6.33.2 kmalloc-8 slab leaks ~512 objects per second
Date: Wed, 12 May 2010 14:04:48 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc7; KDE/4.3.5; x86_64; ; )
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Catalin Marinas <catalin.marinas@arm.com>,
       David Airlie <airlied@linux.ie>
References: <201005121121.49135.tvrtko.ursulin@sophos.com> <g2i84144f021005120600wa8eb0409k13f67f49c519509@mail.gmail.com>
In-Reply-To: <g2i84144f021005120600wa8eb0409k13f67f49c519509@mail.gmail.com>
MIME-Version: 1.0
Message-ID: <201005121404.49720.tvrtko.ursulin@sophos.com>
X-MIMETrack: Itemize by SMTP Server on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 12/05/2010 14:04:49,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 12/05/2010 14:04:50,
	Serialize complete at 12/05/2010 14:04:50
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 7BIT
Content-Type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 May 2010 14:00:51 Pekka Enberg wrote:
> [snip]
>
> You might want to try out the built-in kernel memory leak detector.
> See Documentation/kmemleak.txt for details how to enable it and use
> it.

Thanks for the suggestion, I will have to try it out once but not this time :)
because 2.6.34-rc7 seems to be fine, or in other words not leaking.

Tvrtko

Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon, OX14 3YP, United Kingdom.
Company Reg No 2096520. VAT Reg No GB 348 3873 20.
