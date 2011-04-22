Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985Ab1DVPPV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 11:15:21 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47238 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755905Ab1DVPPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 11:15:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=sezu0KByfXwQgWH59+epy6x7NZAumfxSXjATDDXkoAL9hcwbKs4fuV6RWZk1btJfu9
         MLMNTqvLDljUdRY9lCjEzGFV0RNQyxlyYyol9OMxXB7a8BfRVByNFy3OKED69RoAS/ia
         WGaAhnwYLwoQe6gX8Jq03VV80GsLbTQa/3en0=
Message-ID: <4DB19B80.5000900@gmail.com>
Date: Fri, 22 Apr 2011 19:15:12 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, Don Zickus <dzickus@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] perf, x86: Add PERF_COUNT_HW_NMI_WATCHDOG event
References: <1303398203-2918-1-git-send-email-dzickus@redhat.com>	 <1303398203-2918-5-git-send-email-dzickus@redhat.com>	 <20110422081838.GA24011@elte.hu>	 <BANLkTimh80LorfC8O-HOPAAWK9BLYNjcXA@mail.gmail.com>	 <1303462476.2035.215.camel@laptop>	 <BANLkTi=Eoa9jpiLmFTgcNrY334ZAfz6P=w@mail.gmail.com> <1303465546.2035.224.camel@laptop>
In-Reply-To: <1303465546.2035.224.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2011 01:45 PM, Peter Zijlstra wrote:
...
> 
> Right, so the idea is that one event (concept) has two (or more)
> representations in the config space. And when scheduling the events we
> find we have a conflict, we simply try the alternative encoding(s).
> 
...

  Yeah, Peter, I think it's quite possible to use alternative encoding for p4 as well,
not sure tho if some "generalized" approach for all perf would be applied to p4 but
we can make event "aliases" being per-pmu eventually.

  So Ingo, drop this patch then ;)

-- 
    Cyrill
