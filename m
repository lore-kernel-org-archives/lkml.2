Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932638Ab3AJHyd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 02:54:33 -0500
Received: from co1ehsobe002.messaging.microsoft.com ([216.32.180.185]:49225
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932466Ab3AJHyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 02:54:32 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(zz98dIzz1ee6h1de0h1202h1e76h1d1ah1d2ahzzz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Thu, 10 Jan 2013 15:54:23 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: <rjw@sisk.pl>, <robin.randhawa@arm.com>, <Steve.Bannister@arm.com>,
        <Liviu.Dudau@arm.com>, <linaro-dev@lists.linaro.org>,
        <patches@linaro.org>, <cpufreq@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpufreq: Simplify __cpufreq_remove_dev()
Message-ID: <20130110075422.GA11458@S2101-09.ap.freescale.net>
References: <aa10abe640afed8700abf262dbfc9b9c22659b6a.1357729671.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aa10abe640afed8700abf262dbfc9b9c22659b6a.1357729671.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2013 at 04:50:44PM +0530, Viresh Kumar wrote:
> @Shawn: I believe your driver don't require that ugly code anymore (Though i
> know there is a situation for that to happen, if we have two cpus, you remove
> second one and then add it back. With this cpufreq_add_dev() would call init()
> first and then try to match if there are any managed_policies present. But the
> issue you pointed out about unregistering the driver would be solved by this
> patch.)

Yes, just played it and it works for me.  However, I would have to keep
that little ugly code in my patch to save the dependency on your patch.
Will send a follow-up to clean that up once your patch hits mainline.

Shawn

