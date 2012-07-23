Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748Ab2GWUYS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 16:24:18 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:60148 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754612Ab2GWUYR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 16:24:17 -0400
Message-ID: <500DB2E2.6070703@linaro.org>
Date: Mon, 23 Jul 2012 13:24:02 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: xen-devel@lists.xensource.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Xen-devel] Was: Re: [GIT PULL] timer changes for v3.6, Is: Regression
 introduced by 1e75fa8be9fb61e1af46b5b3b176347a4c958ca1
References: <20120722133441.GA6874@gmail.com> <20120723144917.GF793@phenom.dumpdata.com> <500D8CDD.3060309@linaro.org> <20120723182431.GD21870@phenom.dumpdata.com> <500D9EBC.204@linaro.org> <20120723195144.GA3454@phenom.dumpdata.com>
In-Reply-To: <20120723195144.GA3454@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12072320-7182-0000-0000-0000020F1CBB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2012 12:51 PM, Konrad Rzeszutek Wilk wrote:
>> Does the following resolve it? If not I have a debug patch I'll send
>> you to try to chase this down.
> Yup. That makes it boot without crash and without any WARN_ON.  I am going
> to run it overnight on some other machines but so far it looks to have
> fixed the regression. So please attach:
>
> Reported-and-Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Great! Thanks again so much for the testing and quick reporting!
-john

