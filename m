Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486Ab1DUN6k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 09:58:40 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36437 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150Ab1DUN6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 09:58:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=PyhBltmmO5g04nSllSUMXlAy/t8ce4MbhEy7TyM9dZBrXnma1WnKbxpiaQRa5VC34F
         ACbYUA3ZOKXNw6RVpx7/W5jgX+OA9oGQnpmHyixBrhgeqw90qBPpcQAKpRyTPrmMhDbG
         bqF1HNv6qxRP/tc50Mbd7HfmJG675TAi8/P/Q=
Message-ID: <4DB03809.50806@openvz.org>
Date: Thu, 21 Apr 2011 17:58:33 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Lin Ming <ming.m.lin@intel.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] perf, x86: P4 PMU - Don't forget to clear cpuc->active_mask
 on overflow
References: <4DAEF821.4050103@openvz.org> <20110421125345.GC31724@redhat.com> <20110421131748.GB1642@elte.hu>
In-Reply-To: <20110421131748.GB1642@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2011 05:17 PM, Ingo Molnar wrote:
> 
> * Don Zickus <dzickus@redhat.com> wrote:
> 
>> On Wed, Apr 20, 2011 at 07:13:37PM +0400, Cyrill Gorcunov wrote:
>>> It's not enough to simply disable event on overflow the cpuc->active_mask
>>> should be cleared as well otherwise counter may stall in "active" even
>>> in real being already disabled (which potentially may lead to the situation
>>> that user may not use this counter further).
>>
>> I also noticed this patch fixed some unknown NMIs on a P4 when I stressed
>> the box
>>
>> Acked-by: Don Zickus <dzickus@redhat.com>
> 
> Ok. Mind one of you resending all pending patches in this area, with all 
> Acked-by's and Tested-by's in place?
> 
> I'd like to ask one more thing as well: please submit the patches in a single 
> e-mail thread - i.e. with a proper 0/N and e-mail threading, so that anyone can 
> see that they are a group of patches. Current submissions are various versions 
> of patches with no clear grouping.
> 
> Thanks,
> 
> 	Ingo

Don, will you pick it up in addition to your unknown NMI fast-fix?

-- 
    Cyrill
