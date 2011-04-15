Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757099Ab1DOVII (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 17:08:08 -0400
Received: from higgs.elka.pw.edu.pl ([194.29.160.5]:61387 "EHLO
	higgs.elka.pw.edu.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754067Ab1DOVIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 17:08:07 -0400
X-Comment: RFC 2476 MSA function at elektron.elka.pw.edu.pl logged sender identity as: wzabolot
Message-ID: <4DA8B3A7.3010807@ise.pw.edu.pl>
Date: Fri, 15 Apr 2011 23:07:51 +0200
From: wzab <wzab@ise.pw.edu.pl>
Reply-To: wzab@ise.pw.edu.pl
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20110303 Icedove/3.0.11
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: i915 drm GPU hung errors with kernel 2.6.38.2 on  82865G chipset
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today I have experienced two "GPU hungs" on machine with 82865G chipset 
working with 2.6.38.2 kernel
In the /var/log/syslog I have found the following errors:

Apr 15 22:50:51 wzab kernel: [drm:i915_hangcheck_elapsed] *ERROR* 
Hangcheck timer elapsed... GPU hung
Apr 15 22:50:51 wzab kernel: [drm:i915_do_wait_request] *ERROR* 
i915_do_wait_request returns -11 (awaiting 1352947 at 1352942, next 1352948)
Apr 15 22:50:51 wzab kernel: [drm:init_ring_common] *ERROR* failed to 
set render ring head to zero ctl 00000000 head 3280a54c tail 00000000 
start 00000000
Apr 15 22:50:51 wzab kernel: [drm:init_ring_common] *ERROR* render ring 
initialization failed ctl 0001f003 head 3280a54c tail 00000000 start 
00000000
Apr 15 22:50:52 wzab kernel: [drm:i915_hangcheck_elapsed] *ERROR* 
Hangcheck timer elapsed... GPU hung
Apr 15 22:50:52 wzab kernel: [drm:i915_do_wait_request] *ERROR* 
i915_do_wait_request returns -11 (awaiting 1353049 at 1352942, next 1353050)

After reboot:

Apr 15 22:56:41 wzab kernel: [drm:i915_hangcheck_elapsed] *ERROR* 
Hangcheck timer elapsed... GPU hung
Apr 15 22:56:41 wzab kernel: [drm:i915_do_wait_request] *ERROR* 
i915_do_wait_request returns -11 (awaiting 29134 at 29129, next 29135)

-- 
Regards,
Wojtek
