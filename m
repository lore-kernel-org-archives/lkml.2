Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751730Ab1BEIlF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 03:41:05 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51022 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199Ab1BEIlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 03:41:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=nFvRYEFWzQaa+/wLgeagL7nL+a0iOxULSybw8hjp2XU0PbBmcAZYM1J4scQr3o/aXQ
         kptmgp8/yZPkei/cJNH2KnxcR4IozdpsRuwohXNDMpc0maDM9OXpw7kYefMrmIFUWiL3
         to/6VhzcfmXIAfnHOClWqlJ+K5P+15QxYxMA8=
Message-ID: <4D4D0D1A.8020502@gmail.com>
Date: Sat, 05 Feb 2011 11:40:58 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: George Spelvin <linux@horizon.com>
CC: dzickus@redhat.com, mingo@elte.hu, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, ming.m.lin@intel.com, mroos@linux.ee
Subject: Re: [PATCH] perf, x86: P4 PMU -- Fix unflagged overflows test
References: <20110205022830.19500.qmail@science.horizon.com>
In-Reply-To: <20110205022830.19500.qmail@science.horizon.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2011 05:28 AM, George Spelvin wrote:
> The earlier patch didn't fix things after all.  I'm rebooting with this one now.
> 
> (2.6.38-rc3 wih x86_pmu_start patch.)
> Feb  2 01:00:03: Uhhuh. NMI received for unknown reason 2d on CPU 0.
> Feb  2 01:00:03: Do you have a strange power saving mode enabled?
...

Hi George, this log is when unflagged overflow patch applied or previous one?

-- 
    Cyrill
