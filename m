Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757324Ab1DOViZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 17:38:25 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:58298 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757289Ab1DOViX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 17:38:23 -0400
Date: Fri, 15 Apr 2011 22:38:21 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: wzab <wzab@ise.pw.edu.pl>
Cc: linux-kernel@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: i915 drm GPU hung errors with kernel 2.6.38.2 on  82865G
	chipset
Message-ID: <20110415213821.GA1295@sucs.org>
References: <4DA8B3A7.3010807@ise.pw.edu.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DA8B3A7.3010807@ise.pw.edu.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(CC'ing Chris Wilson)

On Fri, Apr 15, 2011 at 11:07:51PM +0200, wzab wrote:
> Today I have experienced two "GPU hungs" on machine with 82865G chipset  
> working with 2.6.38.2 kernel
> In the /var/log/syslog I have found the following errors:
>
> Apr 15 22:50:51 wzab kernel: [drm:i915_hangcheck_elapsed] *ERROR*  
> Hangcheck timer elapsed... GPU hung
> Apr 15 22:50:51 wzab kernel: [drm:i915_do_wait_request] *ERROR*  
> i915_do_wait_request returns -11 (awaiting 1352947 at 1352942, next 
> 1352948)
> Apr 15 22:50:51 wzab kernel: [drm:init_ring_common] *ERROR* failed to  
> set render ring head to zero ctl 00000000 head 3280a54c tail 00000000  
> start 00000000
> Apr 15 22:50:51 wzab kernel: [drm:init_ring_common] *ERROR* render ring  
> initialization failed ctl 0001f003 head 3280a54c tail 00000000 start  
> 00000000
> Apr 15 22:50:52 wzab kernel: [drm:i915_hangcheck_elapsed] *ERROR*  
> Hangcheck timer elapsed... GPU hung
> Apr 15 22:50:52 wzab kernel: [drm:i915_do_wait_request] *ERROR*  
> i915_do_wait_request returns -11 (awaiting 1353049 at 1352942, next 
> 1353050)
>
> After reboot:
>
> Apr 15 22:56:41 wzab kernel: [drm:i915_hangcheck_elapsed] *ERROR*  
> Hangcheck timer elapsed... GPU hung
> Apr 15 22:56:41 wzab kernel: [drm:i915_do_wait_request] *ERROR*  
> i915_do_wait_request returns -11 (awaiting 29134 at 29129, next 29135)

-- 
Sitsofe | http://sucs.org/~sits/
