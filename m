Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185Ab0JUTjr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 15:39:47 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:60714 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718Ab0JUTjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 15:39:46 -0400
Subject: Re: [PATCH 1/7] x86: Convert remaining clocksources to
 clocksource_register_hz/khz
From: john stultz <johnstul@us.ibm.com>
To: akataria@vmware.com
Cc: LKML <linux-kernel@vger.kernel.org>,
        "jacob.jun.pan@intel.com" <jacob.jun.pan@intel.com>,
        Glauber Costa <glommer@redhat.com>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Jeremy Fitzhardinge <jeremy@xensource.com>,
        Chris McDermott <lcm@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1287688604.27008.16.camel@ank32.eng.vmware.com>
References: <1287618253-13258-1-git-send-email-johnstul@us.ibm.com>
	 <1287618253-13258-2-git-send-email-johnstul@us.ibm.com>
	 <1287688604.27008.16.camel@ank32.eng.vmware.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Oct 2010 12:39:34 -0700
Message-ID: <1287689974.4059.0.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-21 at 12:16 -0700, Alok Kataria wrote:
> Hi John,
> 
> vmiclock_32.c doesn't exist anymore in tip and pretty soon should
> disappear from mainline too. 

Ah. Thanks for the heads up!

-john


