Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758105Ab1DMTGD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 15:06:03 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:37594 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757105Ab1DMTGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 15:06:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qa5sYDK6PvpCzYgRgPL1SSAMNahwjQUbXoR5YfwVBpaztq0uZvMXlWNlH804pz0wqI
         rR57JLOjcOREQ+4IRVl0HiyymDQHpkSHMduBVFr/7Fn5YYvhM2yaqKAi3dP0i0M39wfF
         Quq6jGfIuBRxLieij/k/z2T9IVqiKtYlpbGDw=
Date: Thu, 14 Apr 2011 04:05:54 +0900
From: Tejun Heo <tj@kernel.org>
To: shaohua.li@intel.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, cl@linux.com,
        eric.dumazet@gmail.com
Subject: Re: [patch v2 1/4] percpu_counter: change return value and add
 comments
Message-ID: <20110413190554.GD3987@mtj.dyndns.org>
References: <20110413075715.090406229@sli10-conroe.sh.intel.com>
 <20110413080517.384129355@sli10-conroe.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110413080517.384129355@sli10-conroe.sh.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 03:57:16PM +0800, shaohua.li@intel.com wrote:
> the percpu_counter_*_positive() API SMP and UP aren't consistent. Add comments
> to explain it.
> Also if count < 0, returns 0 instead of 1 for *read_positive().
> 
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>

Patch looks technically okay to me but may I suggest...

* Revise patch description.  It doesn't really match the patch
  content.

* I would much prefer having docbook comments on top of
  *read_positive() functions.

Thanks.

-- 
tejun
