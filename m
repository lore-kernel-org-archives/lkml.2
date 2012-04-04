Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932556Ab2DDTHR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 15:07:17 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932386Ab2DDTHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 15:07:15 -0400
Message-ID: <4F7C9BD7.8000604@nod.at>
Date: Wed, 04 Apr 2012 21:07:03 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org,
        PhillipLougherplougher@redhat.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <greg@kroah.com>,
        Dan Rosenberg <drosenberg@vsecurity.com>, Eugene Teo <eteo@redhat.com>,
        Eric Paris <eparis@redhat.com>, James Morris <jmorris@namei.org>
Subject: Re: [PATCH] sysctl: fix write access to dmesg_restrict/kptr_restrict
References: <20120404184019.GA32681@www.outflux.net>
In-Reply-To: <20120404184019.GA32681@www.outflux.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04.04.2012 20:40, Kees Cook wrote:
> Commit bfdc0b4 adds code to restrict access to dmesg_restrict,
> however, it incorrectly alters kptr_restrict rather than
> dmesg_restrict.
>
> The original patch from Richard Weinberger
> (https://lkml.org/lkml/2011/3/14/362) alters dmesg_restrict as
> expected, and so the patch seems to have been misapplied.
>
> This adds the CAP_SYS_ADMIN check to both dmesg_restrict and
> kptr_restrict, since both are sensitive.
>
> Reported-by: Phillip Lougher<plougher@redhat.com>
> Signed-off-by: Kees Cook<keescook@chromium.org>
> Cc: stable@vger.kernel.org

Acked-by: Richard Weinberger <richard@nod.at>

Thanks,
//richard
