Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734Ab1FSJCQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 05:02:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49363 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752344Ab1FSJCP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 05:02:15 -0400
Message-ID: <4DFDBAFF.4010202@redhat.com>
Date: Sun, 19 Jun 2011 12:01:51 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 0/5] perf support for amd guest/host-only bits v2
References: <1308317854-27398-1-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1308317854-27398-1-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2011 04:37 PM, Joerg Roedel wrote:
> Hi,
>
> this is the second version of the patch-set to support the AMD
> guest-/host only bits in the performance counter MSRs. Due to lack of
> time I havn't looked into emulating support for this feature on Intel or
> other architectures, but the other comments should be worked in. The
> changes to v1 include:

I'll be happy to add Intel support, it's needed for my guest pmu 
patchset anyway.

-- 
error compiling committee.c: too many arguments to function

