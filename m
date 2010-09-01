Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848Ab0IAIno (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 04:43:44 -0400
Received: from mgw-sa02.nokia.com ([147.243.1.48]:55927 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706Ab0IAInm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 04:43:42 -0400
Subject: Re: [PATCH 2/3] mmc_test: change simple_strtol() to strict_strtol()
From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
To: "Quadros Roger (Nokia-MS/Helsinki)" <roger.quadros@nokia.com>
Cc: ext Andy Shevchenko <andy.shevchenko@gmail.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Hunter Adrian (Nokia-MS/Helsinki)" <adrian.hunter@nokia.com>
In-Reply-To: <4C7E0DFA.2090403@nokia.com>
References: <cover.1283276161.git.ext-andriy.shevchenko@nokia.com>
	 <e144c2087fbdfd718b5caeac4eb7d0a7ce4896e0.1283276161.git.ext-andriy.shevchenko@nokia.com>
	 <4C7E0DFA.2090403@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Teleca Finland
Date: Wed, 01 Sep 2010 11:43:25 +0300
Message-ID: <1283330605.3117.12.camel@fs-test.research.nokia.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-01 at 10:25 +0200, Quadros Roger (Nokia-MS/Helsinki)
wrote:

> No patch summary?
Will be in next version.

> > -static void mmc_test_run(struct mmc_test_card *test, int testcase)
> > +static void mmc_test_run(struct mmc_test_card *test, long testcase)
> >   {
> > -	int i, ret;
> > +	long i;
> 
> Why this change? isn't unsigned int sufficient for the mmc test cases?
You are right. This certain change is redundant. I'll skip it.

> > -	testcase = simple_strtol(buf, NULL, 10);
> > +	if (strict_strtol(buf, 10,&testcase))
> space required                    ^ here
It's odd. I have space in my patch.


-- 
With Best Regards,
Andy Shevchenko




