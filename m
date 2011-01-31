Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782Ab1AaN0y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 08:26:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30843 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755408Ab1AaN0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 08:26:53 -0500
Message-ID: <4D46B88C.4000700@redhat.com>
Date: Mon, 31 Jan 2011 15:26:36 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Rik van Riel <riel@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>,
        ttracy@redhat.com, "Nakajima, Jun" <jun.nakajima@intel.com>
Subject: Re: [RFC -v7 PATCH 5/7] export pid symbols needed for kvm_vcpu_on_spin
References: <20110126165657.2ddd2ac9@annuminas.surriel.com>	 <20110126172303.3d5184a7@annuminas.surriel.com> <1296474699.15234.396.camel@laptop>
In-Reply-To: <1296474699.15234.396.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2011 01:51 PM, Peter Zijlstra wrote:
> On Wed, 2011-01-26 at 17:23 -0500, Rik van Riel wrote:
> >  Export the symbols required for a race-free kvm_vcpu_on_spin.
>
> Avi, you asked for an example of why I hated KVM as a module :-)

Why do you dislike exports so much?

-- 
error compiling committee.c: too many arguments to function

