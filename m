Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932353Ab0EYALI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 20:11:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35450 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755185Ab0EYALG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 20:11:06 -0400
Message-ID: <4BFB14BE.8070407@zytor.com>
Date: Mon, 24 May 2010 17:07:26 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: john stultz <johnstul@us.ibm.com>, Brian Bloniarz <bmb@athenacr.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venki@google.com>, chris.mason@oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Export tsc related information in sysfs
References: <4BF58B59.7080901@athenacr.com> <AANLkTinJ36UBMsVvTEoPnmAVS6np9Ja6heEtKA93r7tp@mail.gmail.com> <ce764b91-11b0-44a5-9cf9-96977652bbd5@default> <1274727116.2954.5.camel@localhost.localdomain> <4BFADF9D.9050209@zytor.com> <1274733566.2954.73.camel@localhost.localdomain> <3ec7f284-1507-47fb-b5a2-eea29f68c627@default> <4BFAFE17.8060105@zytor.com> <1274741362.2954.80.camel@localhost.localdomain> <b4a3fe9e-8646-4fb9-93e0-6953be7a0aa9@default 1274743836.2954.104.camel@localhost.localdomain> <bcb35f6d-e632-4fb6-bef0-8c55335ef537@default>
In-Reply-To: <bcb35f6d-e632-4fb6-bef0-8c55335ef537@default>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2010 05:01 PM, Dan Magenheimer wrote:
> On a quick sample of two machines looking at the TSC calibration
> done by Xen (which exposes the equivalent of tsc_khz), it appears
> that the stamped value is different from the calibration by about
> 1000ppm.  YMMV.

So pretty seriously different.  Less than I would have expected, but not
out of the ballpark.

	-hpa
