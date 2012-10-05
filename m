Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757162Ab2JERMp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 13:12:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22733 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757003Ab2JERMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 13:12:43 -0400
X-Authority-Analysis: v=2.0 cv=YP4dOG6x c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=_Ld--4Lr3LMA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=t9ydKhIB5vYA:10 a=UKdR2nmUJvOi79U0rXoA:9 a=PUjeQqilurYA:10 a=UqEjdnmmKsrhZPrT:21 a=Q80flOZFqXrQY8qh:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1349457161.6755.61.camel@gandalf.local.home>
Subject: Re: [PATCHv2.5] trace: reuse kbasename() functionality
From: Steven Rostedt <rostedt@goodmis.org>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Fri, 05 Oct 2012 13:12:41 -0400
In-Reply-To: <CAHp75Vc1a-4LtuTun=urBLvroLqsok4zeW-Fqm-uDK9izmsR6w@mail.gmail.com>
References: <1349253783-21612-7-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1349254399-22742-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1349455743.6755.57.camel@gandalf.local.home>
	 <CAHp75Vc1a-4LtuTun=urBLvroLqsok4zeW-Fqm-uDK9izmsR6w@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-05 at 20:02 +0300, Andy Shevchenko wrote:

> > I don't see kbasename() anywhere. Is this based off of other patches?
> It's introduced by first patch in the series.
> 

Usually a series has the format of:

[PATCH x/n] ....

Where x is the patch number and n is the total number of patches. I'm
not sure what a v2.5 is. This is version 2 and a half?

-- Seve



