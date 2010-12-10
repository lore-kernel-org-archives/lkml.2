Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756364Ab0LJQCU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 11:02:20 -0500
Received: from 184-106-158-135.static.cloud-ips.com ([184.106.158.135]:55032
	"EHLO mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756170Ab0LJQCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 11:02:19 -0500
Date: Fri, 10 Dec 2010 16:02:23 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        LSM <linux-security-module@vger.kernel.org>,
        containers@lists.linux-foundation.org,
        Kees Cook <kees.cook@canonical.com>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 4/4] allow killing tasks in your own or child userns
Message-ID: <20101210160223.GA16601@mail.hallyn.com>
References: <20101209172027.GA10085@mail.hallyn.com>
 <20101209172843.GA10155@mail.hallyn.com>
 <20101209173050.GA10206@mail.hallyn.com>
 <20101209173245.GB10206@mail.hallyn.com>
 <m14oal3mjx.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m14oal3mjx.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> "Serge E. Hallyn" <serge@hallyn.com> writes:
> > +static inline int kill_ok_by_cred(struct cred *cred, struct cred *tcred)
> > +{
> Nit: You should just pass in the target task here.
> Making it abundantly clear where current and tcred come from.
> ns_capable implicitly uses current which is a little surprising
> when everything else is being passed in, but makes perfect sense
> in this context.

Thanks, that makes sense, will do.

If the set seems fine overall, then I'll also look at adding ptrace
controls, and hopefully send the result out next week.

thanks,
-serge
