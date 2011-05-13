Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139Ab1EMERw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 00:17:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57250 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751125Ab1EMERv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 00:17:51 -0400
MIME-Version: 1.0
In-Reply-To: <m1iptf1cm2.fsf@fess.ebiederm.org>
References: <BANLkTi=nc3WGaASQm1Pc9byshLOmLf2bXQ@mail.gmail.com>
 <20110513025013.GA13209@mail.hallyn.com> <m1iptf1cm2.fsf@fess.ebiederm.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 12 May 2011 21:16:58 -0700
Message-ID: <BANLkTin-7HXdbDXaCBmJAncpOauowAB6Bg@mail.gmail.com>
Subject: Re: acl_permission_check: disgusting performance
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        Daniel Lezcano <daniel.lezcano@free.fr>,
        David Howells <dhowells@redhat.com>, James Morris <jmorris@namei.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        containers@lists.linux-foundation.org,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 8:52 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
>
> In any event an inline version of current_user_ns that returns
> init_user_ns in the case where user namespaces aren't compiled in should
> fix the immediate performance problems by allowing the compiler to
> optimize them out.

Yes. However, then Serge's patch in the next email immediately breaks
that optimization ;^(

                            Linus
