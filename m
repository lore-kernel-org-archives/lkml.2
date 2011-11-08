Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278Ab1KHVrh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 16:47:37 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38972 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab1KHVrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 16:47:36 -0500
Message-ID: <4EB9A373.1010508@suse.cz>
Date: Tue, 08 Nov 2011 22:47:31 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net,
        Jiajun Wu <b06378@freescale.com>, Li Yang <leoli@freescale.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jiri Slaby <jirislaby@gmail.com>
Subject: ppc: irq_choose_cpu breaks build [was: Linux 2.6.32.47]
References: <20111107213431.GA8483@kroah.com>
In-Reply-To: <20111107213431.GA8483@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Damn, CCs fixed.

On 11/07/2011 10:34 PM, Greg KH wrote:
> I'm announcing the release of the 2.6.32.47 kernel.
...
> Yang Li (1):
>        powerpc/mpic: Fix problem that affinity is not updated

Hi, this one is broken:
arch/powerpc/sysdev/mpic.c: In function 'irq_choose_cpu':
arch/powerpc/sysdev/mpic.c:574: error: passing argument 1 of 
'__cpus_equal' from incompatible pointer type

Why the backport of the patch misses the cpus_equal -> cpumask_equal switch?

regards,
-- 
js
suse labs
