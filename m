Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638Ab1LISzS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 13:55:18 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:61377 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836Ab1LISzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 13:55:17 -0500
Date: Fri, 9 Dec 2011 10:55:12 -0800
From: Tejun Heo <tj@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] trace_event_filter: factorize filter creation
Message-ID: <20111209185512.GF12108@google.com>
References: <20111123014603.GA19630@google.com>
 <20111123020016.GB19630@google.com>
 <20111128204932.GK18864@google.com>
 <1322518512.17003.34.camel@frodo>
 <20111208233206.GC12108@google.com>
 <1323391594.30977.159.camel@frodo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323391594.30977.159.camel@frodo>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 08, 2011 at 07:46:34PM -0500, Steven Rostedt wrote:
> This has some major conflicts with what is currently in tip/perf/core.
> Could you rebase against it?

I checked tip before sending the patch but it seemed to be lagging
behind mainline.  Just discovered my tree was tracking ingo/tip.git
instead of tip/tip.git.  Gah...

Will send updated patch soon.

Thanks.

-- 
tejun
