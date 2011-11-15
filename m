Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066Ab1KOOtu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 09:49:50 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:39922 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755843Ab1KOOtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 09:49:49 -0500
Date: Tue, 15 Nov 2011 06:49:43 -0800
From: Tejun Heo <tj@kernel.org>
To: Dave Young <dyoung@redhat.com>
Cc: gregkh@suse.de, cl@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCCH percpu: add cpunum param in per_cpu_ptr_to_phys
Message-ID: <20111115144943.GJ30922@google.com>
References: <20111115083646.GA21468@darkstar.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111115083646.GA21468@darkstar.nay.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 15, 2011 at 04:36:46PM +0800, Dave Young wrote:
> per_cpu_ptr_to_phys iterate all cpu to get the phy addr
> let's leave the caller to pass the cpu number to it.
> 
> Actually in the only one user show_crash_notes,
> cpunum is provided already before calling this. 
> 
> Signed-off-by: Dave Young <dyoung@redhat.com>

Does this matter?  If it's not a performance critical path, I'd rather
keep the generic funtionality.

Thanks.

-- 
tejun
