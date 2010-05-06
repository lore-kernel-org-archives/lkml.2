Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759072Ab0EFQbP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 12:31:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:53238 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754824Ab0EFQbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 12:31:14 -0400
Message-ID: <4BE2EEB0.6020402@kernel.org>
Date: Thu, 06 May 2010 18:30:40 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: mingo@elte.hu, peterz@infradead.org, linux-kernel@vger.kernel.org,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Josh Triplett <josh@freedesktop.org>, Oleg Nesterov <oleg@redhat.com>,
       Dimitri Sivanich <sivanich@sgi.com>
Subject: Re: [PATCH 3/4 UPDATED] scheduler: replace migration_thread with
 cpu_stop
References: <1272980864-27235-1-git-send-email-tj@kernel.org> <1272980864-27235-4-git-send-email-tj@kernel.org> <20100505013351.GN2639@linux.vnet.ibm.com> <4BE11E29.6040106@kernel.org> <20100505174725.GA6783@linux.vnet.ibm.com> <4BE1B49F.2020404@kernel.org> <20100505203149.GA2439@linux.vnet.ibm.com>
In-Reply-To: <20100505203149.GA2439@linux.vnet.ibm.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 06 May 2010 16:30:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2010 10:31 PM, Paul E. McKenney wrote:
> Almost.  With the following patch, I am good with it.

Ah, right.  What was I thinking?  I'll include your patch and push it
to Ingo.  Thanks.

-- 
tejun
