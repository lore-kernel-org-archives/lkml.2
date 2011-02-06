Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775Ab1BFTzv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 14:55:51 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51617 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367Ab1BFTzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 14:55:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=LQ91ALTjP0ZepklAMWpL5fdHmpQJOfEQ4RA4OK2eDwSMNZdLWrJbhB/c+sq/9xKzqJ
         RpfVLBm6kP3y8kiw1SXL5OISQc0qyhOIwgEU4nT/nP1qJ5IcHRT3wdTxMvgpTY8aLa8+
         Lt+0UAvOSWjBZqbWA+JhLx1Ql+ZXI8z6NEmZY=
Message-ID: <4D4EFCC1.2080607@gmail.com>
Date: Sun, 06 Feb 2011 22:55:45 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
        fweisbec@gmail.com, perfmon2-devel@lists.sf.net, eranian@gmail.com,
        robert.richter@amd.com, acme@redhat.com, ming.m.lin@intel.com
Subject: Re: [PATCH 0/2] perf_events: add support for Intel fixed counter
 2
References: <4d4bf9ac.cf03d90a.2908.2186@mx.google.com>	<1296825160.26581.652.camel@laptop>	<AANLkTintvA8QUYzJUXWc792uYD-tACCxUzvY_XCQtD=u@mail.gmail.com> <AANLkTimOxf_GZtWwn3fEojKLjeVpQSiAwOn7=vBmiWRz@mail.gmail.com>
In-Reply-To: <AANLkTimOxf_GZtWwn3fEojKLjeVpQSiAwOn7=vBmiWRz@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2011 06:19 PM, Stephane Eranian wrote:
> Hi,
> 
> Ok, another, easier, choice would be to use event code 0 (and
> umaks 0x1 for instance). I doubt that one will ever be used.
> 
> 

Seems so, but there is no guarantee I think (at least for p4 there is
0x0 event (tc-deliver-mode)) though 0x1 should make it unique enough.

-- 
    Cyrill
