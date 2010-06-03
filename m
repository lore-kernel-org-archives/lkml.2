Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525Ab0FCOHQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 10:07:16 -0400
Received: from dallas.jonmasters.org ([72.29.103.172]:41628 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754517Ab0FCOHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 10:07:14 -0400
X-Greylist: delayed 1570 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Jun 2010 10:07:14 EDT
Subject: Re: modules: remove -w option (ie. !O_NONBLOCK)?
From: Jon Masters <jonathan@jonmasters.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <201006032255.33101.rusty@rustcorp.com.au>
References: <201006032255.33101.rusty@rustcorp.com.au>
Content-Type: text/plain; charset="UTF-8"
Organization: World Organi[sz]ation of Broken Dreams
Date: Thu, 03 Jun 2010 09:40:55 -0400
Message-ID: <1275572456.21786.177.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-03 at 22:55 +0930, Rusty Russell wrote:

>    Since waiting module removal was never implemented in modprobe, I wonder
> if we should simply get rid of it?  (It's implemented in rmmod only).
> Unused code is buggy code, and there doesn't seem to be a demand for removing
> modules "at some time in the future".
> 
> Thoughts?

I'll think some more after coffee this morning but my first instinct is
"sure, few people care about module removal anyway any more" :)

Jon.


