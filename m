Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295Ab0LIDe2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 22:34:28 -0500
Received: from mail.solarflare.com ([216.237.3.220]:25250 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460Ab0LIDe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 22:34:27 -0500
Subject: Re: [PATCH 4/7] e1000e: cleanup: fix long lines
From: Ben Hutchings <bhutchings@solarflare.com>
To: Asbjoern Sloth Toennesen <asbjorn@asbjorn.biz>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1291862457-16671-5-git-send-email-asbjorn@asbjorn.biz>
References: <1291862457-16671-1-git-send-email-asbjorn@asbjorn.biz>
	 <1291862457-16671-5-git-send-email-asbjorn@asbjorn.biz>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Thu, 09 Dec 2010 03:34:23 +0000
Message-ID: <1291865663.19763.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Dec 2010 03:34:27.0080 (UTC) FILETIME=[FB151880:01CB9751]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-17816.005
X-TM-AS-Result: No--10.796300-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-09 at 02:40 +0000, Asbjoern Sloth Toennesen wrote:
> This patch breaks long lines, so they do not exceed 80 characters.
> 
> Fixes 2 errors and 26 warnings reported by checkpatch.
[...]

80-character lines are not a strict requirement.  The kernel coding
style is about readability, not slavishingly following rules.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

