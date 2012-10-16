Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab2JPKOz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 06:14:55 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:61050 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088Ab2JPKOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 06:14:53 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohponnT=q5bEgzdSSdPNQnskPMM0BbDdDPR3Cc+Gq5NeK-xg@mail.gmail.com>
References: <1350377120-27657-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<CAOh2x=n-523nC=bM9X5WrWYv=o=aKK_s-+MsA+XVcVP1yy1zFg@mail.gmail.com>
	<CAHp75Vc6aPAqG7gDobjOaiSRqw8MNAG7pS3o-ze6ejXXF7AFEg@mail.gmail.com>
	<CAKohponnT=q5bEgzdSSdPNQnskPMM0BbDdDPR3Cc+Gq5NeK-xg@mail.gmail.com>
Date: Tue, 16 Oct 2012 13:14:52 +0300
Message-ID: <CAHp75VdVLh7JN10YEiA1P=iV-T3enpL639_ZKSsj1ubzvNihNg@mail.gmail.com>
Subject: Re: [PATCH] dmatest: terminate all ongoing transfers before
 submitting new one
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2012 at 12:52 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>>> Also, the proposed solution might hide some other important errors. We may need
>>> to terminate transfers when we found that an error is there in  last transfers:
>> I think it could be better than first solution, but what do you think
>> about marking each transfer with corresponding id?
>
> But dma_test expects the transfer to finish within timeout. If it
> doesn't, then that's
> an error.
>
> So, for testing your s/w emulation, you must pass higher timeout. And
> terminating
> transfers for error case would be better, to make them timeout safe.

Yeah, seems the patch is not necessary.
In case of software emulation we just have a test passed much slow...

-- 
With Best Regards,
Andy Shevchenko
