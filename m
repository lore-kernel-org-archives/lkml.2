Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756361Ab0LROus (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 09:50:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24470 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753197Ab0LROur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 09:50:47 -0500
Message-ID: <4D0CCA26.3020809@redhat.com>
Date: Sat, 18 Dec 2010 09:50:14 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>
Subject: Re: [RFC -v2 PATCH 2/3] sched: add yield_to function
References: <20101213224434.7495edb2@annuminas.surriel.com>	 <20101213224657.7e141746@annuminas.surriel.com> <1292329322.6803.1609.camel@twins>
In-Reply-To: <1292329322.6803.1609.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2010 07:22 AM, Peter Zijlstra wrote:

... fixed all the obvious stuff.   No idea what the hell I was
thinking while doing that "cleanup" - probably too busy looking
at the tests that I was running on a previous codebase :(

For the next version of the patches, I have switched to your
version of yield_to_fair :)

-- 
All rights reversed
