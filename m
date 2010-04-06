Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757144Ab0DFCaQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 22:30:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:45269 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757057Ab0DFCaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 22:30:10 -0400
Message-ID: <4BBA9CAB.4050107@kernel.org>
Date: Tue, 06 Apr 2010 11:30:03 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET linux-next] update gfp/slab.h includes
References: <1269885165-18617-1-git-send-email-tj@kernel.org>
In-Reply-To: <1269885165-18617-1-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 06 Apr 2010 02:30:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Stephen.

On 03/30/2010 02:52 AM, Tejun Heo wrote:
> Mainline is scheduled to be updated not to include slab.h implicitly
> from percpu.h which means that each .c file which uses gfp or slab API
> should include respective header file directly.

You probably have noticed already but both slabh branch and percpu
changes have been merged to mainline, so once these patches are merged
to subsystem trees, there shouldn't be many new breakages showing up
in linux-next.  Thanks a lot for helping testing and fixing up this
huge ugly monster.  Much appreciated.

-- 
tejun
