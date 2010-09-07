Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689Ab0IGIDY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 04:03:24 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:38410 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755199Ab0IGIDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 04:03:14 -0400
Date: Tue, 7 Sep 2010 10:03:03 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Jan Beulich <JBeulich@novell.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "hpa@zytor.com" <hpa@zytor.com>, "mingo@elte.hu" <mingo@elte.hu>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [lm-sensors] [PATCH] x86/hwmon: fix configuration and 
 initialization of coretemp and pkgtemp
Message-ID: <20100907100303.2f45f227@hyperion.delvare>
In-Reply-To: <20100902212505.GA31811@fenghua-desk.sc.intel.com>
References: <4C7FB8370200007800013F40@vpn.id2.novell.com>
	<20100902212505.GA31811@fenghua-desk.sc.intel.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Sep 2010 14:25:05 -0700, Fenghua Yu wrote:
> On Thu, Sep 02, 2010 at 05:44:07AM -0700, Jan Beulich wrote:
> > - using cpuid_eax() to determine feature availability on other than
> >   the current CPU is invalid
> > - feature availability shopuld also be check in the hotplug code path
> > - pkgtemp doesn't depend on PCI altogether (apparently just inherited
> >   from coretemp)
> > - coretemp really only needs PCI for Atom support
> > 
> 
> Could you split the patch into small patches since it handles a few different
> things?

I can only second this request. This should be split into per-driver
patches or per-bug patches, or even both.

Jan, can you please send updated patches? I can't apply that one as is.
Thanks.

-- 
Jean Delvare
