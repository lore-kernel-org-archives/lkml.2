Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017Ab0H1N3R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 09:29:17 -0400
Received: from mail.perches.com ([173.55.12.10]:1027 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751328Ab0H1N3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 09:29:15 -0400
Subject: Re: [PATCH] intel_ips: quieten "power or thermal limit exceeded"
 messages
From: Joe Perches <joe@perches.com>
To: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, mjg@redhat.com,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <4C790693.1060908@cesarb.net>
References: <Pine.LNX.4.30.1008261631410.13713-100000@mail.perches.com>
	 <4C770299.6000708@cesarb.net> <1282869660.1836.5.camel@Joe-Laptop>
	 <4C77171E.6060008@cesarb.net> <1282894751.1836.41.camel@Joe-Laptop>
	 <4C784650.2030200@cesarb.net> <1282962104.1946.179.camel@Joe-Laptop>
	 <4C78E8EF.1000009@cesarb.net> <1282994116.1946.226.camel@Joe-Laptop>
	 <4C790693.1060908@cesarb.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 28 Aug 2010 06:29:14 -0700
Message-ID: <1283002154.1946.268.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-08-28 at 09:52 -0300, Cesar Eduardo Barros wrote:
> Em 28-08-2010 08:15, Joe Perches escreveu:
> >> I will try to enable dev_dbg() later and see what it prints.
> > or add:
[]
> Here it is:
> 
> intel ips 0000:00:1f.6: Warning: CPU TDP doesn't match expected value 
> (found 25, expected 35)
> intel ips 0000:00:1f.6: PCI INT C -> GSI 18 (level, low) -> IRQ 18
> intel ips 0000:00:1f.6: show_turbo_limits:ips_probe cte:1 gte:1 cpt:0 
> mpl:65535 mtl:65535 mpl:65535

So ips->core_power_limit is still 0.

Is it bad bios or driver?

I expect the bios/hw is faulty but fingers are easy to point.

Your choice on how to minimize your current logging problem.

Changing the message level to dev_dbg probably isn't the
right thing to do overall, but it may suit you right now.

Thanks for testing.

