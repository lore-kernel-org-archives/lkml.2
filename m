Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756446Ab0JDPzL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 11:55:11 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53373 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756406Ab0JDPzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 11:55:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NyOOaOYKQwXT9wO5G9kqPbSsHSj6Tcb43XCuBnHudafUBT8/37/sTK7EtYyLNIol2H
         fe0BWF+5HXg0EV5TQrBxxYOGLU0sGXyfI1xa9H6Ll8jVhtIsO/mor4o75em6HduaYocT
         wztJjvTR+e0LPaHnQkPJajnW4xBkWvGKkvQlA=
Date: Mon, 4 Oct 2010 17:54:44 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] workqueue: Add a trace event for works enqueuing
Message-ID: <20101004155410.GA5381@nowhere>
References: <1285861140-5948-1-git-send-regression-fweisbec@gmail.com> <4CA9E8E0.7040503@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CA9E8E0.7040503@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 04, 2010 at 04:46:56PM +0200, Tejun Heo wrote:
> Sorry about the delay.  I was off last week.
> 
> How about something like this?  It probably needs to be split into two
> patches.  It provides more information on which CPU was requested and
> eventually chosen and separates queueing and activation which can be
> useful for analyzing latency or freezer issues.
> 
> Thanks.



Yep looks good. I hadn't thought about frozen works.

Thanks.

(I think this should go through your tree rather than the tracing tree).

