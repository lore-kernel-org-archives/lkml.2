Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758913Ab1DNOdp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 10:33:45 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55221 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758845Ab1DNOdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 10:33:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=JvAvSfGRwcYd92Lhh7dnz9WahASUha3p+4qaPA8jSNFuvp28yI4rBA1OcUNtLX763l
         /YRsV2QdqbwlwdWUl9FkNGIDE/x1oAqZln8WgLri/o3UmpEseRTJXPIKHqlKX60N2Sj4
         F9c4W3sPsbKOog15AojCh/v+LNSYLh8ZzGtDM=
Message-ID: <4DA705C0.8000300@openvz.org>
Date: Thu, 14 Apr 2011 18:33:36 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Shaun Ruffell <sruffell@digium.com>
CC: Don Zickus <dzickus@redhat.com>, maciej.rutecki@gmail.com,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Lin Ming <ming.m.lin@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Robert Richter <robert.richter@amd.com>
Subject: Re: [regression 2.6.39-rc2][bisected] "perf, x86: P4 PMU - Read proper
 MSR register to catch" and NMIs
References: <20110406223036.GA15721@digium.com> <201104132133.51958.maciej.rutecki@gmail.com> <4DA6011F.7070405@openvz.org> <20110413203501.GA10744@digium.com> <4DA60B03.30603@openvz.org> <20110413212208.GJ16939@redhat.com> <4DA614DF.5090304@openvz.org> <20110413215322.GA11670@digium.com> <20110414143024.GA13458@digium.com>
In-Reply-To: <20110414143024.GA13458@digium.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2011 06:30 PM, Shaun Ruffell wrote:
> On Wed, Apr 13, 2011 at 04:53:22PM -0500, Shaun Ruffell wrote:
>> On Thu, Apr 14, 2011 at 01:25:51AM +0400, Cyrill Gorcunov wrote:
>> ...
>>> OK, thanks for review! Shaun please continue testing it, if all will be fine until tomorrow
>>> we will ask Ingo to pick it up then. Sounds OK for everyone?
>>
>> Sounds good. I'll let it run tonight with v2 tonight.
> 
> I know Ingo asked to merge v1 now and something else in a later version.
> However, just to follow up on this thread, v2 ran all night without producing
> any NMIs on the PowerEdge 2600.
> 
> Cheers,
> Shaun

Thanks Shaun, I'll send v1 shortly, just to be on safe side.
Then we will update it for .40 as Ingo proposed. Thanks again
for testing!

-- 
    Cyrill
