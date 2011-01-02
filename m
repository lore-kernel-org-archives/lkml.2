Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996Ab1ABOiY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 09:38:24 -0500
Received: from 184-106-158-135.static.cloud-ips.com ([184.106.158.135]:33203
	"EHLO mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754281Ab1ABOiW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 09:38:22 -0500
Date: Sun, 2 Jan 2011 14:39:20 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        LSM <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Kees Cook <kees.cook@canonical.com>,
        containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [RFC 4/5] user namespaces: allow killing tasks in your own or
 child userns
Message-ID: <20110102143920.GA1560@mail.hallyn.com>
References: <20101217152246.GA8221@mail.hallyn.com>
 <20101217152458.GA11162@mail.hallyn.com>
 <20101217152547.GB11162@mail.hallyn.com>
 <20101217152625.GC11162@mail.hallyn.com>
 <20101217152659.GD11162@mail.hallyn.com>
 <m14oacryar.fsf@fess.ebiederm.org>
 <20101217200903.GA15528@mail.hallyn.com>
 <m1d3p0qhl5.fsf@fess.ebiederm.org>
 <20110101044522.GA26476@mail.hallyn.com>
 <m1zkrkuso4.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1zkrkuso4.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> > +static inline int kill_ok_by_cred(struct task_struct *t)
> > +{
> > +	struct cred *cred = current_cred();
> > +	struct cred *tcred = __task_cred(t);

(Note, here and elsewhere these should have been const.  My next posting,
with some new patches, will have that fix)

thanks,
-serge
