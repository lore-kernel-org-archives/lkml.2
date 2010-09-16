Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756384Ab0IPV7H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 17:59:07 -0400
Received: from xenotime.net ([72.52.115.56]:33235 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756358Ab0IPV7G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 17:59:06 -0400
Message-ID: <47010.148.87.67.141.1284674336.squirrel@www.xenotime.net>
In-Reply-To: <201009162256.04765.pedrogfrancisco@gmail.com>
References: <201009162256.04765.pedrogfrancisco@gmail.com>
Date: Thu, 16 Sep 2010 14:58:56 -0700 (PDT)
Subject: Re: ahci rmmodable and shouldn't
From: "Randy Dunlap" <rdunlap@xenotime.net>
To: "Pedro Francisco" <pedrogfrancisco@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
User-Agent: SquirrelMail/1.5.1
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, September 16, 2010 2:56 pm, Pedro Francisco wrote:
> I reported this here for 2.6.35.4 -- http://lkml.org/lkml/2010/9/7/321 --
> but still happens on latest -git.

Please copy linux-ide@vger.kernel.org on ATA issues.
(done now)

> `rmmod ahci' works even if the module is being used (`lsmod' thinks it's
> not being used but rmmoding ahci triggers filesystem erros and I've to
> force a reboot).
>
> I've been told it's the same as plugging a cable. IMO that's what
> /sys/stuff/eject_or_similar is to, not `rmmod ahci'.
>
>
> I *assume* it was caused by the split between libahci & ahci, since in
> 2.6.32
> `rmmod ahci' is impossible because it's marked as being in use. Didn't try
>  `rmmod -f ahci' but that's not the point.
>
>
> I'm posting again about this because it doesn't make sense to me the
> actual behaviour.
>
> TIA,
> --
> Pedro
> --

-- 
~Randy

