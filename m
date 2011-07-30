Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177Ab1G3XKF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 19:10:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:48189 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab1G3XJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 19:09:58 -0400
Subject: Re: [patch] x86, x2apic: enable the bios request for x2apic optout
From: David Woodhouse <dwmw2@infradead.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Song, Youquan" <youquan.song@intel.com>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        Prarit Bhargava <prarit@redhat.com>, trenn@suse.de
Date: Sun, 31 Jul 2011 00:09:45 +0100
In-Reply-To: <1311987173.12777.7.camel@sbsiddha-mobl2>
References: <1311987173.12777.7.camel@sbsiddha-mobl2>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1312067391.22074.58.camel@i7.infradead.org>
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-29 at 17:52 -0700, Suresh Siddha wrote:
> 
> +               WARN(!eim, KERN_WARNING "Your BIOS is broken and requested that"
> +                          " x2apic be disabled\n This will leave your machine"
> +                          " vulnerable to irq-injection attacks\n Use"
> +                          " 'intremap=no_x2apic_optout' to override BIOS "
> +                          "request\n"); 

Please don't break strings, except at the \n. I think checkpatch.pl even
has an exception to its 80-column rule for this, these days?

If I see this message and search in the kernel source for the string
'requested that x2apic be disabled', I should be able to find it.

-- 
dwmw2

