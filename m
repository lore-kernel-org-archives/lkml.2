Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab1FSKF7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 06:05:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21265 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752886Ab1FSKFz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 06:05:55 -0400
Message-ID: <4DFDC9F9.5020300@redhat.com>
Date: Sun, 19 Jun 2011 13:05:45 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Eric B Munson <emunson@mgebm.net>
Subject: Re: [PATCH v2 6/7] KVM-GST: adjust scheduler cpu power
References: <1308262856-5779-1-git-send-email-glommer@redhat.com> <1308262856-5779-7-git-send-email-glommer@redhat.com>
In-Reply-To: <1308262856-5779-7-git-send-email-glommer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2011 01:20 AM, Glauber Costa wrote:
> This is a first proposal for using steal time information
> to influence the scheduler. There are a lot of optimizations
> and fine grained adjustments to be done, but it is working reasonably
> so far for me (mostly)
>
> With this patch (and some host pinnings to demonstrate the situation),
> two vcpus with very different steal time (Say 80 % vs 1 %) will not get
> an even distribution of processes. This is a situation that can naturally
> arise, specially in overcommited scenarios. Previosly, the guest scheduler
> would wrongly think that all cpus have the same ability to run processes,
> lowering the overall throughput.
>

Looks fine, but sched maintainer review needed.

-- 
error compiling committee.c: too many arguments to function

