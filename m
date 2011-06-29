Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534Ab1F2JsF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 05:48:05 -0400
Received: from 8bytes.org ([88.198.83.132]:51809 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754452Ab1F2JsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 05:48:04 -0400
Date: Wed, 29 Jun 2011 11:48:02 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Avi Kivity <avi@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Joerg Roedel <joerg.roedel@amd.com>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 0/5] perf support for amd guest/host-only bits v2
Message-ID: <20110629094802.GI29299@8bytes.org>
References: <1308317854-27398-1-git-send-email-joerg.roedel@amd.com> <20110628161000.GF29299@8bytes.org> <1309338174.6701.929.camel@twins> <4E0AF014.4060402@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E0AF014.4060402@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 12:27:48PM +0300, Avi Kivity wrote:
> On 06/29/2011 12:02 PM, Peter Zijlstra wrote:
>> >
>> >  have you had a chance to look at this patch-set? Are any changes
>> >  required?
>>
>> I would feel a lot more comfortable by having it implemented on all of
>> x86 as well as at least one !x86 platform. Avi graciously volunteered
>> for the Intel bits.
>
> Silly me.  Joerg, can you post the git tree publicly please?

Okay, I pushed it to
	
	git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-kvm.git perf-guest-counting

It probably takes some time until it appears on the mirrors.

Thanks,

	Joerg
