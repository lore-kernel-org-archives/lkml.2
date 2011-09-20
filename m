Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921Ab1ITHzT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 03:55:19 -0400
Received: from fsmail-out.f-secure.com ([193.110.108.171]:38451 "EHLO
	fsmail-out.f-secure.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283Ab1ITHzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 03:55:18 -0400
Message-ID: <4E7846E5.1010909@f-secure.com>
Date: Tue, 20 Sep 2011 10:55:17 +0300
From: Tarkan Erimer <tarkan.erimer@f-secure.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110907 Thunderbird/6.0.2
MIME-Version: 1.0
To: Chris Wilson <chris@chris-wilson.co.uk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] i915 crashes X Server Constantly on Linux-3.1-rc4 to .rc6
References: <4E770FF5.8030207@f-secure.com> <aefc95$1fgrb6@orsmga001.jf.intel.com> <4E773E65.5040809@f-secure.com> <aefc95$1fih8n@orsmga001.jf.intel.com> <4E782C62.507@f-secure.com> <e39f63$1l0gme@fmsmga002.fm.intel.com>
In-Reply-To: <e39f63$1l0gme@fmsmga002.fm.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.4.6813,1.0.211,0.0.0000
 definitions=2011-09-20_02:2011-09-20,2011-09-20,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2011 10:34 AM, Chris Wilson wrote:
> I've tried this on a few 32/64 bit machines (using different chips just
> in case) on a few different distros. No instant death, I'll keep poking just
> in case. Since flash is a sw rasteriser and uses ShmPutImage to update
> its screen contents, these are typically an invalid memcpy. Having the
> debug symbols would help confirm that and pinpoint which path.
>
> Going back and checking your Xorg.log, I think you need this fix:
>
> commit 3565c48c4bb77c836d817de75d098791dbb529d3
> Author: Chris Wilson<chris@chris-wilson.co.uk>
> Date:   Wed Sep 14 17:45:41 2011 +0100
>
>      sna: Yet another s/x/y/ typo
>
>      Every time I do a transformation into pixmap space I like to include one
>      of these copy'n'paste errors.
>
>      Reported-by: Paul Neumann<paul104x@yahoo.de>
>      Bugzilla:https://bugs.freedesktop.org/show_bug.cgi?id=40850
>      Signed-off-by: Chris Wilson<chris@chris-wilson.co.u

Chris,

Many thanks for your help and debugging. I will try that and then will 
let you know.

Cheers,
Tarkan



-- 
Tarkan Erimer
IT Service Deployment / 3rd Level Support / Snr. Linux Engineer

