Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932121Ab1FQJOB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 05:14:01 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59199 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757358Ab1FQJN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 05:13:59 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DFB1AB6.4020104@jp.fujitsu.com>
Date: Fri, 17 Jun 2011 18:13:26 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Paul Turner <pjt@google.com>
CC: Hu Tao <hutao@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.co>
Subject: Re: [patch 00/15] CFS Bandwidth Control V6
References: <20110503092846.022272244@google.com> <20110614065807.GA19111@localhost.localdomain> <4DF70DED.2030803@jp.fujitsu.com> <20110615083749.GA14200@localhost.localdomain> <4DF954E5.9060704@jp.fujitsu.com> <20110616094508.GA1961@localhost.localdomain> <4DFAAC6B.6060306@jp.fujitsu.com> <BANLkTikDYdxed6=C6Lfht3WZM-=HSqDDKA@mail.gmail.com>
In-Reply-To: <BANLkTikDYdxed6=C6Lfht3WZM-=HSqDDKA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/06/17 15:25), Paul Turner wrote:
> It should be out in a few hours, as I was preparing everything today I
> realized an latent error existed in the quota expiration path;
> specifically that on a wake-up from a sufficiently long sleep we will
> see expired quota and have to wait for the timer to recharge bandwidth
> before we're actually allowed to run.  Currently munging the results
> of fixing that and making sure everything else is correct in the wake
> of those changes.

Thanks!
I'll check it some time early next week.


Thanks,
H.Seto

