Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533Ab0CYNoI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 09:44:08 -0400
Received: from lon1-post-2.mail.demon.net ([195.173.77.149]:47250 "EHLO
	lon1-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751314Ab0CYNoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 09:44:06 -0400
Subject: Re: [PATCH] trace: reorder struct ring_buffer_per_cpu to remove
 padding on 64bit
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: rostedt@goodmis.org
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@infradead.org>
In-Reply-To: <1269524290.2957.4073.camel@gandalf.stny.rr.com>
References: <1269516456.2054.8.camel@localhost>
	 <1269524290.2957.4073.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Mar 2010 13:44:03 +0000
Message-ID: <1269524643.2054.13.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-25 at 09:38 -0400, Steven Rostedt wrote:
> On Thu, 2010-03-25 at 11:27 +0000, Richard Kennedy wrote:
> > Reorder structure to remove 8 bytes of padding on 64 bit builds.
> > This shrinks the size to 128 bytes so allowing allocation from a smaller
> > slab & needed one fewer cache lines.
> > 
> 
> Thanks!
> 
> Just curious, did you use Arnaldo's pahole utility to find this?
> 
> -- Steve
No, but something similar I guess. I wrote my own tool that parses the
debug data & filters out the interesting results ;)

Richard

