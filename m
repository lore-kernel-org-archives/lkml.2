Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932201Ab0LRUcD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 15:32:03 -0500
Received: from elasmtp-banded.atl.sa.earthlink.net ([209.86.89.70]:39212 "EHLO
	elasmtp-banded.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932108Ab0LRUcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 15:32:02 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=fAfUoW/JBifoX4+GxrKnaN0oFKtpYdD+jYW52rRcFpWi18SNvAJdRvj02lLId/N3;
  h=Received:Message-ID:Date:From:Reply-To:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Message-ID: <4D0D19FF.4020600@earthlink.net>
Date: Sat, 18 Dec 2010 15:30:55 -0500
From: Stephen Clark <sclark46@earthlink.net>
Reply-To: sclark46@earthlink.net
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: sclark46@earthlink.net
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: I915 driver locks up
References: <4D0D1516.3040404@earthlink.net>
In-Reply-To: <4D0D1516.3040404@earthlink.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: a437fbc6971e80f61aa676d7e74259b7b3291a7d08dfec79ba727239cc0735bd6387b8ad025e1112350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 69.22.83.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2010 03:09 PM, Stephen Clark wrote:
> Hi,
>
> I am using 2.6.35.9-64.fc14.x86_64 running 1.3.9-1.fc14.x86_64
> and am having my 945gma lock up in texture decompress according
> to intel_gpu_top utility, when trying to play Myst 5.
>
> Any fixes on the horizon?
>
Additional data point with 2.6.37-0.rc6.git0.1.fc15.x86_64 from rawhide 
I get:
[  307.256028] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer 
elapsed... GPU hung
[  307.258118] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request 
returns -11 (awaiting 27197 at 27195, next 27199)
[  307.258975] [drm:i915_reset] *ERROR* Failed to reset chip.

and my X screen goes weird - have to switch to vty console.



-- 

"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty
decreases."  (Thomas Jefferson)



