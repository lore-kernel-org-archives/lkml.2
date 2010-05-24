Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756371Ab0EXUjj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 16:39:39 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:47012 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733Ab0EXUjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 16:39:37 -0400
Subject: Re: [PATCH] x86: Export tsc related information in sysfs
From: john stultz <johnstul@us.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>,
       Brian Bloniarz <bmb@athenacr.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venki@google.com>, chris.mason@oracle.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <4BFADF9D.9050209@zytor.com>
References: <4BF58B59.7080901@athenacr.com AANLkTinJ36UBMsVvTEoPnmAVS6np9Ja6heEtKA93r7tp@mail.gmail.com>
	 <ce764b91-11b0-44a5-9cf9-96977652bbd5@default>
	 <1274727116.2954.5.camel@localhost.localdomain>
	 <4BFADF9D.9050209@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 24 May 2010 13:39:26 -0700
Message-ID: <1274733566.2954.73.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-24 at 13:20 -0700, H. Peter Anvin wrote:
> On 05/24/2010 11:51 AM, john stultz wrote:
> > 
> > Hmmm. That could be an option for newer cpus that I wouldn't oppose.
> > 
> > While Peter is correct that the stamped value is probably not very
> > accurate, atleast it would be constant from boot to boot, and NTP's
> > calculated drift value would be correct. 
> > 
> > We'd need a check to make sure its not way off, since NTP will give up
> > if its outside 500ppm.  So as long as its close to the calibrated value,
> > we probably could use it.
> > 
> 
> Is that still the case?  I thought newer versions of NTP could deal with
> large values.  Inaccuracies of way more than 500 ppm are everyday.

That's scary. 

Yea, in the kernel the ntp freq correction tops out at 500ppm. Almost
all the systems I see tend to fall in the +/- 200ppm range (if there's
not something terribly wrong with the hardware).

So maybe things aren't so bad out there? Or is that wishful thinking?

thanks
-john


