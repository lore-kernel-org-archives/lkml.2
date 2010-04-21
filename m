Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755Ab0DUNk6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 09:40:58 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:43734 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754719Ab0DUNk4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 09:40:56 -0400
Date: Wed, 21 Apr 2010 08:40:53 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Ashwin Ganti <ashwin.ganti@gmail.com>,
       Greg KH <greg@kroah.com>, rsc@swtch.com, ericvh@gmail.com,
       linux-security-module@vger.kernel.org, Ron Minnich <rminnich@gmail.com>,
       jt.beard@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
       Andrew Morgan <morgan@kernel.org>, oleg@us.ibm.com,
       Eric Paris <eparis@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 1/3] p9auth: split core function out of some
 set*{u,g}id functions
Message-ID: <20100421134053.GD16326@us.ibm.com>
References: <20100421012749.GA21338@us.ibm.com>
 <23079.1271846817@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23079.1271846817@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting David Howells (dhowells@redhat.com):
> Serge E. Hallyn <serue@us.ibm.com> wrote:
> 
> > +int cred_setresuid(struct cred *new, uid_t ruid, uid_t euid, uid_t suid,
> > +		   int force);
> > +int cred_setresgid(struct cred *new, gid_t rgid, gid_t egid, gid_t sgid,
> > +		   int force);
> > +int cred_setfsuid(struct cred *new, uid_t uid, uid_t *old_fsuid);
> > +int cred_setfsgid(struct cred *new, gid_t gid, gid_t *old_fsgid);
> 
> Can you mark these extern please?
> 
> Other than that, these functions should probably be mentioned in
> Documentation/credentials.txt.
> 
> David

Will do.

thanks,
-serge
