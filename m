Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975Ab1BEJWs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 04:22:48 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37969 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999Ab1BEJWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 04:22:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=prMPA9SpYzSAjzA8RR21vf2jlt6fkSn3TeNajT/CqbzpPqC3Sor+IxDoUNKkevrjrY
         uPTX+4cwPmj4NQHtcpc6S8IgtQTaYDvbPlzuw0Av+T16yDNDbgtMUjRicdPBIlSMppxj
         YpD5pvmP+IDrUCqn36K7isQXEfEkgW8CNrIGQ=
Message-ID: <4D4D16E3.5040205@gmail.com>
Date: Sat, 05 Feb 2011 12:22:43 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: George Spelvin <linux@horizon.com>
CC: a.p.zijlstra@chello.nl, dzickus@redhat.com, linux-kernel@vger.kernel.org,
        ming.m.lin@intel.com, mingo@elte.hu, mroos@linux.ee
Subject: Re: [PATCH] perf, x86: P4 PMU -- Fix unflagged overflows test
References: <20110205091536.11125.qmail@science.horizon.com>
In-Reply-To: <20110205091536.11125.qmail@science.horizon.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2011 12:15 PM, George Spelvin wrote:
>> Hi George, this log is when unflagged overflow patch applied or previous one?
> 
> The earlier one.  As I said, the patch to x86_pmu_start.  The later one (no
> complaints in 6 hours of uptime so far) was to p4_pmu_clear_cccr_ovf.
> 
> Thank you very much!

Thanks for testing George! There is still a problem with kgdb bootup tests,
but at moment I didn't resolve this thing. Will ping as only get any news ;)

-- 
    Cyrill
