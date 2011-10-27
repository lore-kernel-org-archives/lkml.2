Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784Ab1J0Oq1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 10:46:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55196 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963Ab1J0Oq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 10:46:26 -0400
Date: Thu, 27 Oct 2011 10:46:21 -0400
From: Dave Jones <davej@redhat.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Vincent Guittot <vincent.guittot@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, cpufreq@vger.kernel.org
Subject: Re: [PATCH RESEND] cpufreq: db8500: remove unneeded for loop
 iteration for freq_table
Message-ID: <20111027144621.GA24961@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>, cpufreq@vger.kernel.org
References: <1319684744.4598.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319684744.4598.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 27, 2011 at 11:05:44AM +0800, Axel Lin wrote:
 > We alread did policy->cur = db8500_cpufreq_getspeed(policy->cpu);
 > Don't know why to do the loop iteration here. It looks useless.
 > 
 > Signed-off-by: Axel Lin <axel.lin@gmail.com>

already queued. still waiting for my kernel.org account.
(blocked on waiting for gpg signatures to be uploaded)

	Dave
