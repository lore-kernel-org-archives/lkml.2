Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779Ab0I1PVB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 11:21:01 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:11364 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754169Ab0I1PVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 11:21:00 -0400
Date: Tue, 28 Sep 2010 17:20:23 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Jan Beulich <JBeulich@novell.com>,
        "r.marek@assembler.cz" <r.marek@assembler.cz>,
        "fenghua.yu@intel.com" <fenghua.yu@intel.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: x86/hwmon: conditionalize coretemp's dependency on PCI
Message-ID: <20100928172023.75607337@endymion.delvare>
In-Reply-To: <20100928120000.GA7139@ericsson.com>
References: <4C8E18790200007800015AF7@vpn.id2.novell.com>
	<20100924185509.GA20155@ericsson.com>
	<4CA05F220200007800018F81@vpn.id2.novell.com>
	<20100927121650.GB31847@ericsson.com>
	<4CA0AE5E0200007800019097@vpn.id2.novell.com>
	<20100927130220.GA2277@ericsson.com>
	<20100928091759.421b5bf2@endymion.delvare>
	<20100928120000.GA7139@ericsson.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Sep 2010 05:00:00 -0700, Guenter Roeck wrote:
> On Tue, Sep 28, 2010 at 03:17:59AM -0400, Jean Delvare wrote:
> > Do you mean it is strange from a technical perspective, or do you have
> > evidences that it doesn't work properly? This trick come from Intel
> > themselves, I would guess they know their business.
>
> From a technical perspective. Hard to see what a PCI bridge ID has to do with Tjmax.

I agree. If you search the archives, you'll see I emitted exactly the
same complaint back then.

> > (...)
> > Higher or lower doesn't make a difference. As long as the coretemp
> > driver doesn't properly report the temperature values as being
> > relative, users don't expect the value to change depending on the
> > kernel version or configuration options. We have had dozens of user
> > reports because of this.
> > 
> You are right, functionality would change if someone runs a kernel with PCI undefined 
> on the specific systems which do use the PCI bridge ID to determine Tjmax. So 
> if there are no other options, maybe the big fat warning in that case would make sense.
> I would definitely prefer that over disabling coretemp entirely just because it _might_
> possibly report a wrong Tjmax (which it doees anyway for many CPUs).

I fully agree.

-- 
Jean Delvare
