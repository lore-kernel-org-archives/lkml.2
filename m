Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275Ab1CQSvX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 14:51:23 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:38643 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755182Ab1CQSvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 14:51:20 -0400
Date: Thu, 17 Mar 2011 12:51:16 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: "Lai, Mee Sim" <mee.sim.lai@intel.com>
Cc: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ewe, Kok Howg" <kok.howg.ewe@intel.com>,
        "'Toshiharu Okada'" <toshiharu-linux@dsn.okisemi.com>
Subject: Re: About GPIO interrupt function with sysfs
Message-ID: <20110317185116.GA10565@angua.secretlab.ca>
References: <F5323EE7947C4C1CB0868F843FB4F917@hacdom.okisemi.com>
 <AANLkTim4z7vfyNceLYZhGzpYaECeSfLOYjzEhT9JFvJH@mail.gmail.com>
 <BF5CB373A5A948A2976AE727EA3F6B70@hacdom.okisemi.com>
 <20110303185632.GL22940@angua.secretlab.ca>
 <2BC88E699A3D491E8B7C2B761F8296C7@hacdom.okisemi.com>
 <1FCD1EEA68DED942B626C91DF9B9AA81271FE6C238@pgsmsx502.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1FCD1EEA68DED942B626C91DF9B9AA81271FE6C238@pgsmsx502.gar.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10, 2011 at 11:13:05PM +0800, Lai, Mee Sim wrote:
> Hi Grant,
> Is there any update on this? thanks!

Nope, nor did I make any promises that I would have the time to do so.
Sorry.

g.

> 
> Thanks & Regards,
> Michelle Lai Mee Sim
> Software Platform Application Engineer
> inet:82532218
> 
> -----Original Message-----
> From: Tomoya MORINAGA [mailto:tomoya-linux@dsn.okisemi.com] 
> Sent: Friday, March 04, 2011 8:06 AM
> To: 'Grant Likely'
> Cc: linux-kernel@vger.kernel.org; Ewe, Kok Howg; Lai, Mee Sim; 'Toshiharu Okada'
> Subject: RE: About GPIO interrupt function with sysfs
> 
> Hi Grant, 
> 
> On Friday, March 04, 2011 3:57 AM, Grant Likely wrote:
> > I don't know.  I'll need to dig into that code before I can 
> > answer.  I suggest digging into it yourself to figure out the 
> > answer as I cannot promise that I'll get to it anytime soon.
> 
> Seeing "gpio_to_irq" of another architecture (e.g. ARM), there is significant code in it.
> In addition, you can see "Not implemented, yet" description in "arch/x86/include/asm/gpio.h"
> Thus, I suspect that x86 GPIO sysfs can't support interrupt function at present.
> 
> Thanks,
> -----------------------------------------
> Tomoya MORINAGA
> OKI SEMICONDUCTOR CO., LTD.
> 
