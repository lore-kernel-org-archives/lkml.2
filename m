Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832Ab1ELNYH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 09:24:07 -0400
Received: from goliath.siemens.de ([192.35.17.28]:21905 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910Ab1ELNYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 09:24:05 -0400
Message-ID: <4DCBDF5B.6000101@siemens.com>
Date: Thu, 12 May 2011 15:23:39 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: Avi Kivity <avi@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH v1 0/5] KVM in-guest performance monitoring
References: <1305129333-7456-1-git-send-email-avi@redhat.com> <20110512093309.GD8707@8bytes.org> <4DCBACC7.8080000@siemens.com> <20110512131130.GG8707@8bytes.org>
In-Reply-To: <20110512131130.GG8707@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-05-12 15:11, Joerg Roedel wrote:
> On Thu, May 12, 2011 at 11:47:51AM +0200, Jan Kiszka wrote:
>> On 2011-05-12 11:33, Joerg Roedel wrote:
> 
>>> Anyway, I thought about a paravirt-approach instead of implementing a
>>> real PMU... But there are certainly good reasons for both.
>>
>> Paravirt is taking away the pressure from CPU vendors to do their virt
>> extensions properly - and doesn't help with unmodifiable OSes.
> 
> Seriously, I think such decisions should be technical only and not
> political like that. The losers of such political decisions are always
> the users because they don't get useful features that are technical
> possible.

Paravirt remains a workaround, useful until hardware provides a solution
for all guests, and that often in an even more efficient way (like for
MMU virtualization).

We do not need to block a PV-PMU for Linux guests (or other OSes that
want to adopt to it), but that will not be a solution for the problem,
that's my point. A PV-PMU may even be useful to demonstrate usefulness
of a virtual PMU the CPU vendors (if they aren't aware of this yet).

Jan

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
