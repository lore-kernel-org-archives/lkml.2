Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932295Ab1BXDPH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 22:15:07 -0500
Received: from 184-106-158-135.static.cloud-ips.com ([184.106.158.135]:56961
	"EHLO mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932071Ab1BXDPF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 22:15:05 -0500
Date: Thu, 24 Feb 2011 03:15:18 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        LSM <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Kees Cook <kees.cook@canonical.com>,
        containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>, xemul@parallels.com,
        dhowells@redhat.com
Subject: Re: [PATCH] userns: ptrace: incorporate feedback from Eric
Message-ID: <20110224031518.GA4963@mail.hallyn.com>
References: <20110217150224.GA26334@mail.hallyn.com>
 <20110217150333.GE26395@mail.hallyn.com>
 <m1aahu9hea.fsf@fess.ebiederm.org>
 <20110218043601.GB9584@mail.hallyn.com>
 <20110224004901.GB11822@mail.hallyn.com>
 <20110223165651.cf248f3b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110223165651.cf248f3b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew Morton (akpm@linux-foundation.org):
> On Thu, 24 Feb 2011 00:49:01 +0000
> "Serge E. Hallyn" <serge@hallyn.com> wrote:
> 
> > same_or_ancestore_user_ns() was not an appropriate check to
> > constrain cap_issubset.  Rather, cap_issubset() only is
> > meaningful when both capsets are in the same user_ns.
> 
> I queued this as a fix against
> userns-allow-ptrace-from-non-init-user-namespaces.patch, but I get the
> feeling that it would be better to just drop everything and start
> again?

Sure, I'll rebase and resend.  I wonder if I should trim the Cc list
for the next round.

thanks,
-serge
