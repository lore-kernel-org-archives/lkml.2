Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016Ab1EQJwT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 05:52:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47607 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753908Ab1EQJwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 05:52:17 -0400
Message-ID: <4DD24544.1000408@redhat.com>
Date: Tue, 17 May 2011 12:52:04 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH v1 0/5] KVM in-guest performance monitoring
References: <1305129333-7456-1-git-send-email-avi@redhat.com>
In-Reply-To: <1305129333-7456-1-git-send-email-avi@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2011 06:55 PM, Avi Kivity wrote:
> perf maintainers: please consider the first three patches for merging (the
> first two make sense even without the rest).  If you're familiar with the Intel
> PMU, please review patch 5 as well - it effectively undoes all your work
> of abstracting the PMU into perf_events by unabstracting perf_events into what
> is hoped is a very similar PMU.

Perf maintainers, ping?

-- 
error compiling committee.c: too many arguments to function

