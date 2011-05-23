Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264Ab1EWSFH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 14:05:07 -0400
Received: from imr3.ericy.com ([198.24.6.13]:43690 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757223Ab1EWSFC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 14:05:02 -0400
Subject: Re: [lm-sensors] linux-next: Tree for May 23 (hwmon/coretemp.c)
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        Rudolf Marek <r.marek@assembler.cz>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        Fenghua Yu <fenghua.yu@intel.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20110523104958.98ef4d1a.randy.dunlap@oracle.com>
References: <20110523154518.5e27cfb0.sfr@canb.auug.org.au>
	 <20110523104958.98ef4d1a.randy.dunlap@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Ericsson
Date: Mon, 23 May 2011 11:03:37 -0700
Message-ID: <1306173817.2163.354.camel@groeck-laptop>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sigh. And I was sure I tested that :(. I'll look into it immediately.

Guenter

On Mon, 2011-05-23 at 13:49 -0400, Randy Dunlap wrote:
> On Mon, 23 May 2011 15:45:18 +1000 Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > Changes since 20110520:
> 
> when CONFIG_SMP is not enabled:
> 
> drivers/hwmon/coretemp.c:765: error: implicit declaration of function 'cpu_sibling_mask'
> 
> 
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> _______________________________________________
> lm-sensors mailing list
> lm-sensors@lm-sensors.org
> http://lists.lm-sensors.org/mailman/listinfo/lm-sensors


