Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527Ab1BXA5J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 19:57:09 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41203 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754539Ab1BXA5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 19:57:07 -0500
Date: Wed, 23 Feb 2011 16:56:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        LSM <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Kees Cook <kees.cook@canonical.com>,
        containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>, xemul@parallels.com,
        dhowells@redhat.com
Subject: Re: [PATCH] userns: ptrace: incorporate feedback from Eric
Message-Id: <20110223165651.cf248f3b.akpm@linux-foundation.org>
In-Reply-To: <20110224004901.GB11822@mail.hallyn.com>
References: <20110217150224.GA26334@mail.hallyn.com>
	<20110217150333.GE26395@mail.hallyn.com>
	<m1aahu9hea.fsf@fess.ebiederm.org>
	<20110218043601.GB9584@mail.hallyn.com>
	<20110224004901.GB11822@mail.hallyn.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Feb 2011 00:49:01 +0000
"Serge E. Hallyn" <serge@hallyn.com> wrote:

> same_or_ancestore_user_ns() was not an appropriate check to
> constrain cap_issubset.  Rather, cap_issubset() only is
> meaningful when both capsets are in the same user_ns.

I queued this as a fix against
userns-allow-ptrace-from-non-init-user-namespaces.patch, but I get the
feeling that it would be better to just drop everything and start
again?

