Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477Ab0EZUUG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 16:20:06 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:46575 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756831Ab0EZUUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 16:20:04 -0400
Subject: Re: [PATCH] x86: Export tsc related information in sysfs
From: john stultz <johnstul@us.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Brian Bloniarz <bmb@athenacr.com>,
       Dan Magenheimer <dan.magenheimer@oracle.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venki@google.com>, chris.mason@oracle.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <4BFD6DAD.1000302@zytor.com>
References: <4BF58B59.7080901@athenacr.com>
	 <AANLkTinJ36UBMsVvTEoPnmAVS6np9Ja6heEtKA93r7tp@mail.gmail.com>
	 <ce764b91-11b0-44a5-9cf9-96977652bbd5@default>
	 <1274727116.2954.5.camel@localhost.localdomain>
	 <4BFADF9D.9050209@zytor.com 1274733566.2954.73.camel@localhost.localdomain>
	 <3ec7f284-1507-47fb-b5a2-eea29f68c627@default> <4BFAFE17.8060105@zytor.com>
	 <4BFB2902.50308@athenacr.com>  <4BFC687A.9040304@athenacr.com>
	 <1274834888.4678.66.camel@localhost.localdomain>
	 <4BFC8C77.7020802@athenacr.com> <1274886299.1759.8.camel@work-vm>
	 <4BFD4629.6040602@athenacr.com> <1274891109.1759.27.camel@work-vm>
	 <4BFD6C2B.4070403@athenacr.com>  <4BFD6DAD.1000302@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 May 2010 13:19:37 -0700
Message-ID: <1274905177.3383.47.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-26 at 11:51 -0700, H. Peter Anvin wrote:
> On 05/26/2010 11:44 AM, Brian Bloniarz wrote:
> > On 05/26/2010 12:25 PM, john stultz wrote:
> >> Brian: is this something the NTPd folks actually want? Has anyone
> >> checked with them before we hand down the solution from high upon on
> >> lkml mountain?
> > 
> > I haven't checked, it's been a while since I dealt with
> > this problem. The NTP maintainers definitely complain about the
> > quick TSC calibration code like it's a bug:
> > (e.g. http://www.mail-archive.com/questions@lists.ntp.org/msg02079.html).
> > Anyway I'll reach out before I spend any time investing in
> > a solution that they don't want (and you don't like :).
> > 
> 
> Yes, Prof. Mills in particular (for those who don't know, he's "Mr.
> NTP") really gets upset about the way Linux does timekeeping.
> Unfortunately it's not clear to me that he's willing to work with us as
> opposed to wanting things to work exactly like BSD, and swive the
> non-NTP users.

Although I suspect his dislike for Linux is historical, as Roman
reworked the ntp code to follow the NTPv4 reference implementation back
in the 2.6.19 timeframe.

However I'd be more then happy to try to address any specific
deficiencies with Linux's NTP implementation if someone can better
express Prof Mills' critiques are.

thanks
-john




