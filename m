Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932121Ab0EXSY0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 14:24:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56970 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758266Ab0EXSYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 14:24:15 -0400
Message-ID: <4BFAC34C.5020606@zytor.com>
Date: Mon, 24 May 2010 11:19:56 -0700
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
References: <4BF58B59.7080901@athenacr.com AANLkTinJ36UBMsVvTEoPnmAVS6np9Ja6heEtKA93r7tp@mail.gmail.com> <ce764b91-11b0-44a5-9cf9-96977652bbd5@default>
In-Reply-To: <ce764b91-11b0-44a5-9cf9-96977652bbd5@default>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2010 11:13 AM, Dan Magenheimer wrote:
> Just wondering:  If one were to put an ultra-precise scope on
> a processor, how far off would the calibrated value be?  I'd
> imagine the process of calibrating one unknown crystal against
> a second crystal which has a known-but-not-highly-precise
> frequency, though good enough for most purposes, is not particularly
> accurate. In other words, maybe the stamped rate is more accurate
> than the calibrated rate anyway?

No.  Not even close.

A spread-spectrum clock is inaccurate by entire percentage points.
A non-spread clock is typically ±50 ppm with typical consumer PC
oscillators, ±1 ppm with non-crappy but still cheap oscillators (e.g.
used in cell phones.)

	-hpa
