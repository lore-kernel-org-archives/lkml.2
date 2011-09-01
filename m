Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967Ab1IAGiw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 02:38:52 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:36342 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754464Ab1IAGis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 02:38:48 -0400
Date: Wed, 31 Aug 2011 23:38:45 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Nick Bowler <nbowler@elliptictech.com>
Cc: Karel Zak <kzak@redhat.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, util-linux@vger.kernel.org
Subject: Re: [ANNOUNCE] util-linux v2.20
Message-Id: <20110831233845.d9435e52.rdunlap@xenotime.net>
In-Reply-To: <20110901051558.GA14777@elliptictech.com>
References: <20110829122344.GI1855@nb.net.home>
	<20110901051558.GA14777@elliptictech.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Sep 2011 01:15:58 -0400 Nick Bowler wrote:

> Hi Karel,
> 
> On 2011-08-29 14:23 +0200, Karel Zak wrote:
> > The stable util-linux 2.20 release is available at
> > 
> >    ftp://ftp.kernel.org/pub/linux/utils/util-linux/v2.20/
> > 
> > Feedback and bug reports, as always, are welcomed.
> 
> Just upgraded on one of my machines today, and I was surprised to
> discover that only a small portion of my kernel log was printed by
> dmesg.  "busybox dmesg" and "dmesg -r" both print the full log (~2000
> lines), but plain "dmesg" prints only the first ~150 lines or so.  2.19
> dmesg worked fine.
> 
> The last few lines printed by plain "dmesg" are:
> 
>   [...]
>   ACPI: Added _OSI(Module Device)
>   ACPI: Added _OSI(Processor Device)
>   ACPI: Added _OSI(3.0 _SCP Extensions)
>   ACPI: Added _OSI(Processor Aggregator Device)
>   ACPI: EC: Look up EC in DSDT
>   ACPI: Executed 1 blocks of module-level executable AML code
>   ACPI: Actual Package length (234) is larger than NumElements field (3), truncated
> 
> Adding the -r option gives much more:
> 
>   [...]
>   <6>ACPI: Added _OSI(Module Device)
>   <6>ACPI: Added _OSI(Processor Device)
>   <6>ACPI: Added _OSI(3.0 _SCP Extensions)
>   <6>ACPI: Added _OSI(Processor Aggregator Device)
>   <7>ACPI: EC: Look up EC in DSDT
>   <4>ACPI: Executed 1 blocks of module-level executable AML code
>   <4>ACPI: Actual Package length (234) is larger than NumElements field (3), truncated
>   <4>
>   <6>ACPI: Interpreter enabled
>   <6>ACPI: (supports S0 S5)
>   <6>ACPI: Using IOAPIC for interrupt routing
>   <6>ACPI: Power Resource [ISAV] (on)
>   <6>ACPI: No dock devices found.
>   [...]
> 
> So it looks like it's tripping over the blank line in the log?

Karel sent a message earlier (Wed. AUG 31) to util-linux@vger.kernel.org,
Subject: dmesg(1) bug

that explains that and includes a patch.

See http://marc.info/?l=util-linux-ng&m=131478775113617&w=2


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
