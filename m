Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351Ab1F2J2R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 05:28:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62051 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753750Ab1F2J2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 05:28:12 -0400
Message-ID: <4E0AF014.4060402@redhat.com>
Date: Wed, 29 Jun 2011 12:27:48 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Joerg Roedel <joro@8bytes.org>, Joerg Roedel <joerg.roedel@amd.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 0/5] perf support for amd guest/host-only bits v2
References: <1308317854-27398-1-git-send-email-joerg.roedel@amd.com>	 <20110628161000.GF29299@8bytes.org> <1309338174.6701.929.camel@twins>
In-Reply-To: <1309338174.6701.929.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2011 12:02 PM, Peter Zijlstra wrote:
> >
> >  have you had a chance to look at this patch-set? Are any changes
> >  required?
>
> I would feel a lot more comfortable by having it implemented on all of
> x86 as well as at least one !x86 platform. Avi graciously volunteered
> for the Intel bits.

Silly me.  Joerg, can you post the git tree publicly please?

-- 
error compiling committee.c: too many arguments to function

