Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161097Ab2JXSxa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 14:53:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60353 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161041Ab2JXSx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 14:53:29 -0400
Message-ID: <5088391C.6080603@zytor.com>
Date: Wed, 24 Oct 2012 11:53:16 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Jacob Shin <jacob.shin@amd.com>
CC: Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Tom Rini <trini@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: BUG: 1bbbbe7 (x86: Exclude E820_RESERVED regions...) PANIC on
 boot
References: <20121022144020.GA14425@jshin-Toonie> <CAE9FiQWvVNCK8Ka6rq+RMf3u4JFn8D18rGMy4Hpz7Rhnrn6VTA@mail.gmail.com> <20121022183858.GA31185@jshin-Toonie> <CAE9FiQWZmwa6EwsfZzz_e3A-tz2LUS2+i+zh4zpXpR_Jj_FQ1w@mail.gmail.com> <5085ABEF.3060502@linux.intel.com> <CAE9FiQW0rQFUgjiYjByA91XCUUqo59zz2kXc9Z5wXk+3vKPKaQ@mail.gmail.com> <5085B207.5010907@linux.intel.com> <CAE9FiQVt5LN6_wDvS2G+UULD4Ba2CF=zLhg4RULSKbfbct0NLg@mail.gmail.com> <5085BA4A.30800@zytor.com> <CAE9FiQVZirvaBMFYRfXMmWEcHbKSicQEHz4VAwUv0xFCk51ZNw@mail.gmail.com> <20121024164808.GA11779@jshin-Toonie>
In-Reply-To: <20121024164808.GA11779@jshin-Toonie>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2012 09:48 AM, Jacob Shin wrote:
> 
> hpa, we need this patch: https://lkml.org/lkml/2012/8/24/469 and the above
> 2 from Yinghai to handle corner case E820 layouts.
> 

I can apply Yinghai's patches, but the above patch no longer applies.
Could you refresh it on top of tip:x86/u, please?

	-hpa

