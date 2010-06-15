Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758088Ab0FOPVl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 11:21:41 -0400
Received: from adelie.canonical.com ([91.189.90.139]:34546 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809Ab0FOPVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 11:21:39 -0400
Subject: Re: [PATCH v2] trace-cmd: prevent print_graph_duration buffer
 overflow
From: Chase Douglas <chase.douglas@canonical.com>
To: Steven Rostedt <srostedt@redhat.com>
Cc: Valdis.Kletnieks@vt.edu, Frederic Weisbecker <fweisbec@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1276613661.13426.56.camel@localhost.localdomain>
References: <1276613224-19247-1-git-send-email-chase.douglas@canonical.com>
	 <1276613661.13426.56.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Jun 2010 11:21:34 -0400
Message-ID: <1276615294.19578.1.camel@cndougla-ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-15 at 10:54 -0400, Steven Rostedt wrote:
> Quick note. Please send to my rostedt@goodmis.org address. I may not see
> messages here for weeks at a time. I author patches with my RH account
> just to "advertise" who I work for. But I sign-off-by with the account I
> want people to send to.

Ahh. I took the email address from the authors line like you said :). Is
this standard practice for others as well?

> On Tue, 2010-06-15 at 10:47 -0400, Chase Douglas wrote:
> > Passing n > sizeof(string) to snprintf can cause a glibc buffer overflow
> > condition. We know the exact size of nsecs_str, so use it along with the
> > the math to determine the longest string size we want.
> > 
> > Note that an overflow isn't really possible given the format of the
> > string. However, glibc would abort due to a runtime check.
> > 
> > Signed-off-by: Chase Douglas <chase.douglas@canonical.com>
> 
> Thanks!
> 
> Can you write a similar patch for the Linux kernel too. It may need to
> go to stable as well.

Sure

-- Chase

