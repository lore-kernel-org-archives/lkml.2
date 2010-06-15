Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932426Ab0FOPjR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 11:39:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56375 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932400Ab0FOPjD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 11:39:03 -0400
Subject: Re: [PATCH v2] trace-cmd: prevent print_graph_duration buffer
 overflow
From: Steven Rostedt <srostedt@redhat.com>
To: Chase Douglas <chase.douglas@canonical.com>
Cc: Valdis.Kletnieks@vt.edu, Frederic Weisbecker <fweisbec@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1276615294.19578.1.camel@cndougla-ubuntu>
References: <1276613224-19247-1-git-send-email-chase.douglas@canonical.com>
	 <1276613661.13426.56.camel@localhost.localdomain>
	 <1276615294.19578.1.camel@cndougla-ubuntu>
Content-Type: text/plain
Organization: Red Hat
Date: Tue, 15 Jun 2010 11:38:55 -0400
Message-Id: <1276616335.13426.57.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-15 at 11:21 -0400, Chase Douglas wrote:
> On Tue, 2010-06-15 at 10:54 -0400, Steven Rostedt wrote:
> > Quick note. Please send to my rostedt@goodmis.org address. I may not see
> > messages here for weeks at a time. I author patches with my RH account
> > just to "advertise" who I work for. But I sign-off-by with the account I
> > want people to send to.
> 
> Ahh. I took the email address from the authors line like you said :). Is
> this standard practice for others as well?

Probably not, but I like to confuse people ;-)

-- Steve


