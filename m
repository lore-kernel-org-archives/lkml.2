Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757005Ab2FEHrV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 03:47:21 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63951 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756539Ab2FEHrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 03:47:19 -0400
MIME-Version: 1.0
In-Reply-To: <4FCD14F1.1030105@gmail.com>
References: <20120507121527.GA19526@lizard>
	<4FA82056.2070706@gmail.com>
	<CAOJsxLHQcDZSHJZg+zbptqmT9YY0VTkPd+gG_zgMzs+HaV_cyA@mail.gmail.com>
	<CAHGf_=q1nbu=3cnfJ4qXwmngMPB-539kg-DFN2FJGig8+dRaNw@mail.gmail.com>
	<CAOJsxLFAavdDbiLnYRwe+QiuEHSD62+Sz6LJTk+c3J9gnLVQ_w@mail.gmail.com>
	<CAHGf_=pSLfAue6AR5gi5RQ7xvgTxpZckA=Ja1fO1AkoO1o_DeA@mail.gmail.com>
	<CAOJsxLG1+zhOKgi2Rg1eSoXSCU8QGvHVED_EefOOLP-6JbMDkg@mail.gmail.com>
	<20120601122118.GA6128@lizard>
	<alpine.LFD.2.02.1206032125320.1943@tux.localdomain>
	<4FCC7592.9030403@kernel.org>
	<20120604113811.GA4291@lizard>
	<4FCD14F1.1030105@gmail.com>
Date: Tue, 5 Jun 2012 10:47:18 +0300
X-Google-Sender-Auth: VfUf6q7FqdXOjonR_rMAbxvDIKY
Message-ID: <CAOJsxLHR4wSgT2hNfOB=X6ud0rXgYg+h7PTHzAZYCUdLs6Ktug@mail.gmail.com>
Subject: Re: [PATCH 0/5] Some vmevent fixes...
From: Pekka Enberg <penberg@kernel.org>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>, Minchan Kim <minchan@kernel.org>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 4, 2012 at 11:05 PM, KOSAKI Motohiro
<kosaki.motohiro@gmail.com> wrote:
>> Note that 1) and 2) are not problems per se, it's just implementation
>> details, easy stuff. Vmevent is basically an ABI/API, and I didn't
>> hear anybody who would object to vmevent ABI idea itself. More than
>> this, nobody stop us from implementing in-kernel vmevent API, and
>> make Android Lowmemory killer use it, if we want to.
>
> I never agree "it's mere ABI" discussion. Until the implementation is ugly,
> I never agree the ABI even if syscall interface is very clean.

I don't know what discussion you are talking about.

I also don't agree that something should be merged just because the
ABI is clean. The implementation must also make sense. I don't see how
we disagree here at all.
