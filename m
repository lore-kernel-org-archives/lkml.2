Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932753Ab1CWMWJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 08:22:09 -0400
Received: from elasmtp-scoter.atl.sa.earthlink.net ([209.86.89.67]:42196 "EHLO
	elasmtp-scoter.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755086Ab1CWMWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 08:22:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=tp9Uyq1URyryO3otzZi6/355ForK+cczDFgsUcdAUpBNM+bCq39fGtCAMkG15juJ;
  h=Received:Message-ID:Date:From:Reply-To:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Message-ID: <4D89E5E1.3070402@earthlink.net>
Date: Wed, 23 Mar 2011 08:21:53 -0400
From: Stephen Clark <sclark46@earthlink.net>
Reply-To: sclark46@earthlink.net
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Dave Airlie <airlied@linux.ie>, Chris Wilson <chris@chris-wilson.co.uk>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Keith Packard <keithp@keithp.com>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [git pull] drm next tree
References: <alpine.DEB.2.00.1103170403160.3429@skynet.skynet.ie> <AANLkTinoTs89ThBnZ17+fPE+t1V=GycKq2EJG-LadFZQ@mail.gmail.com>
In-Reply-To: <AANLkTinoTs89ThBnZ17+fPE+t1V=GycKq2EJG-LadFZQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-ELNK-Trace: a437fbc6971e80f61aa676d7e74259b7b3291a7d08dfec79fcdfe6b3fd7a7b567b8b36a3e101c75b350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 69.22.83.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2011 10:19 PM, Linus Torvalds wrote:
> So I had  hoped - yes, very naïve of me, I know - that this merge
> window would be different.
>
> But it's not.
>
> On Wed, Mar 16, 2011 at 9:09 PM, Dave Airlie<airlied@linux.ie>  wrote:
>    
>> i915: big 855 fix, lots of output setup refactoring, lots of misc fixes.
>>      
> .. and apparently a lot of breakage too. My crappy laptop that I abuse
> for travel is - once more - broken by the updates. I cannot suspend
> and resume, because every resume seems to fail.
>
> One of the more useful failures was:
>
> [   61.656055] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer
> elapsed... GPU hung
> [   61.656079] [drm] capturing error event; look for more information
> in /debug/dri/0/i915_error_state
> [   61.664387] [drm:i915_wait_request] *ERROR* i915_wait_request
> returns -11 (awaiting 2 at 0, next 3)
>
> and I'm attaching the error_state file from that particular case here.
> In other cases it seems to just hang entirely.
>
> Keith/Jesse/Chris - I don't know that it's i915, and it will take
> forever to bisect (I'll try). But it does seem pretty likely.
>
>                               Linus
>    
Why can't the gpu be reset/restarted when this happens? When a nic card 
gets hung it is reinitialized
and restarted why not the gpu?

-- 

"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty
decreases."  (Thomas Jefferson)



