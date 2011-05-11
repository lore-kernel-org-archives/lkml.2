Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950Ab1EKP5y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:57:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5751 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756215Ab1EKP5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:57:51 -0400
Message-ID: <4DCA94B7.7090001@redhat.com>
Date: Wed, 11 May 2011 16:52:55 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Joerg Roedel <joerg.roedel@amd.com>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 1/3] perf, core: Introduce attrs to count in either host
 or guest mode
References: <1305038132-5080-1-git-send-email-joerg.roedel@amd.com>	 <1305038132-5080-2-git-send-email-joerg.roedel@amd.com>	 <4DCA76A5.7030000@redhat.com>  <4DCA76D7.2010608@redhat.com> <1305121745.2914.216.camel@laptop>
In-Reply-To: <1305121745.2914.216.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2011 04:49 PM, Peter Zijlstra wrote:
> On Wed, 2011-05-11 at 14:45 +0300, Avi Kivity wrote:
> >  Well, actually, that depends on the meaning of exclude_hv.
>
> exclude_hv is for when the host is a guest and we don't wish to sample
> the host's host etc. PPC introduced this because ppc-linux runs as a
> guest of the 'firmware' and not on the native hardware.

Okay.  A comment is needed there to explain the differences then.

-- 
error compiling committee.c: too many arguments to function

