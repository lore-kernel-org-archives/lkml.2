Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751538Ab0HOXWE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 19:22:04 -0400
Received: from tundra.namei.org ([65.99.196.166]:60338 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751108Ab0HOXWB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 19:22:01 -0400
Date: Mon, 16 Aug 2010 09:21:55 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: John Johansen <john.johansen@canonical.com>
cc: Jiri Slaby <jslaby@suse.cz>, jirislaby@gmail.com,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 1/1] AppArmor: fix task_setrlimit prototype
In-Reply-To: <4C62A2DA.2030201@canonical.com>
Message-ID: <alpine.LRH.2.00.1008160920490.14791@tundra.namei.org>
References: <1281518882-4130-1-git-send-email-jslaby@suse.cz> <4C62A2DA.2030201@canonical.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Aug 2010, John Johansen wrote:

> > -static int apparmor_task_setrlimit(unsigned int resource,
> > -				   struct rlimit *new_rlim)
> > +static int apparmor_task_setrlimit(struct task_struct *task,
> > +		unsigned int resource, struct rlimit *new_rlim)
> >  {
> >  	struct aa_profile *profile = aa_current_profile();
> >  	int error = 0;
> 
> thanks Jiri, I'll get an update for apparmor handling task part out today.
> 
> Signed-off-by: John Johansen <john.johansen@canonical.com>

I added my own merge fix for this before seeing this email -- please send 
me an update against

git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next


-- 
James Morris
<jmorris@namei.org>
