Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932290Ab0HNALj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 20:11:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43215 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932242Ab0HNALi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 20:11:38 -0400
Message-ID: <4C65DF22.5090406@zytor.com>
Date: Fri, 13 Aug 2010 17:11:14 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Mike Frysinger <vapier.adi@gmail.com>
CC: Borislav Petkov <petkovbb@googlemail.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [GIT PULL] core/hweight changes for v2.6.35
References: <20100517212138.GA21629@elte.hu> <AANLkTikvJna6vnc73RVhVAJZ8mERJoFk=V6Nwq-3HHWz@mail.gmail.com> <4C65BF90.6000302@zytor.com> <AANLkTikaHsbdM0XSaHH1iE9p8cYE=YFM3an=+xB-JKgZ@mail.gmail.com>
In-Reply-To: <AANLkTikaHsbdM0XSaHH1iE9p8cYE=YFM3an=+xB-JKgZ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2010 02:59 PM, Mike Frysinger wrote:
> 
> but those targets still define CONFIG_GENERIC_HWEIGHT right ?  so at
> the least, we should be wrapping the prototypes in linux/bitops.h with
> that ...
> 

Yes, I guess they do.

	-hpa
