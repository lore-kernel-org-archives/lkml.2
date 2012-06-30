Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457Ab2F3TeT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2012 15:34:19 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:60125 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093Ab2F3TeS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2012 15:34:18 -0400
MIME-Version: 1.0
In-Reply-To: <CAMP5XgceDFLrk3a1yfPHiap56Nvc2XOyvmS9yOrJ9ULVYLbGeQ@mail.gmail.com>
References: <1340232467-6023-1-git-send-email-john.stultz@linaro.org>
	<1340232467-6023-12-git-send-email-john.stultz@linaro.org>
	<CACRpkdZJwocwwFUeVte+NTN83LRaiBvis9nHWV0KUj9htsDoQg@mail.gmail.com>
	<CAMP5XgceDFLrk3a1yfPHiap56Nvc2XOyvmS9yOrJ9ULVYLbGeQ@mail.gmail.com>
Date: Sat, 30 Jun 2012 21:34:16 +0200
Message-ID: <CACRpkdYw7eK24tjsONidhQmbji+mLMk=MTn_vS+torusFYEY5A@mail.gmail.com>
Subject: Re: [PATCH 11/15] ARM: etm: Check arch version and disable data
 tracing for ptm
From: Linus Walleij <linus.walleij@linaro.org>
To: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
Cc: John Stultz <john.stultz@linaro.org>, LKML <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2012 at 11:31 PM, Arve Hjønnevåg <arve@android.com> wrote:
> On Thu, Jun 28, 2012 at 9:07 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
>> On Thu, Jun 21, 2012 at 12:47 AM, John Stultz <john.stultz@linaro.org> wrote:
>>
>>> +#define ETMR_ID                        0x1e4
>>> +#define ETMIDR_VERSION(x)      (((x) >> 4) & 0xff)

Damned I was reading 0x0fe4 ...

> Those values do not come from the same register. The revision is
> duplicated there, but I did not find the major and minor etm version
> which is what I'm looking at.

OK sorry for getting this backwards.

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
