Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617Ab0EUNgK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 09:36:10 -0400
Received: from ns2.intersolute.de ([193.110.43.67]:40450 "EHLO
	ns2.intersolute.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025Ab0EUNgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 09:36:08 -0400
X-Greylist: delayed 1314 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 May 2010 09:36:07 EDT
Message-ID: <4BF68721.4060602@lumino.de>
Date: Fri, 21 May 2010 15:14:09 +0200
From: Michael Schnell <mschnell@lumino.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-2.3 Thunderbird/3.0.4
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Question about futex_atomic_cmpxchg_inatomic
References: <0D753D10438DA54287A00B0270842697636F05337A@AUSP01VMBX24.collaborationhost.net>
In-Reply-To: <0D753D10438DA54287A00B0270842697636F05337A@AUSP01VMBX24.collaborationhost.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2010 01:46 AM, H Hartley Sweeten wrote:
> Should the all arch implementations be changed to use the u32 type, 
>   

I suppose the Futex variable should be a 64 bit entity with a 64 bit
architecture.

-Michael
