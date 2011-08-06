Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385Ab1HFIDg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 04:03:36 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49673 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129Ab1HFID2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 04:03:28 -0400
Date: Sat, 6 Aug 2011 10:03:23 +0200
From: Tejun Heo <tj@kernel.org>
To: Rabin Vincent <rabin@rab.in>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        x86@kernel.org
Subject: Re: [PATCH] stop_machine: build unconditionally if SMP
Message-ID: <20110806080323.GB23937@htj.dyndns.org>
References: <1312614073-11516-1-git-send-email-rabin@rab.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312614073-11516-1-git-send-email-rabin@rab.in>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, Aug 06, 2011 at 12:31:13PM +0530, Rabin Vincent wrote:
> stop_machine() is built for "(SMP && MODULE_UNLOAD) || HOTPLUG_CPU", but
> is also used by the timekeeping code, the mm code, ftrace, and couple of
> things in arch/*.  Just build it if we're using SMP, like it's already
> the case on x86.
> 
> Cc: x86@kernel.org
> Cc: Tejun Heo <tj@kernel.org>
> Signed-off-by: Rabin Vincent <rabin@rab.in>

Yeah, looks good to me.

Acked-by: Tejun Heo <tj@kernel.org>

Andrew, can you please route this one?

Thank you.

-- 
tejun
