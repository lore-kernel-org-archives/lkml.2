Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968138Ab2ERWdI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 18:33:08 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:53372 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759725Ab2ERWdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 18:33:04 -0400
MIME-Version: 1.0
In-Reply-To: <1337284200-1838-1-git-send-email-auke-jan.h.kok@intel.com>
References: <1337284200-1838-1-git-send-email-auke-jan.h.kok@intel.com>
Date: Sat, 19 May 2012 00:33:03 +0200
Message-ID: <CAFLxGvzZ_YJS25wK=YHCELwJOZZuhdeoB6S5Yw_TMVEXzTofOg@mail.gmail.com>
Subject: Re: [PATCH] Trace event for capable().
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Auke Kok <auke-jan.h.kok@intel.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Paris <eparis@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2012 at 9:50 PM, Auke Kok <auke-jan.h.kok@intel.com> wrote:
> Add a simple trace event for capable().
>
> There's been a lot of discussion around capable(), and there
> are plenty of tools to help reduce capabilities' usage from
> userspace. A major gap however is that it's almost impossible
> to see or verify which bits are requested from either userspace
> or in the kernel.
>
> This patch adds a minimal tracer that will print out which
> CAPs are requested and whether the request was granted.

Can we please have support for user namespaces?
At least idicate whether the current namespace is init_user_ns or not.

-- 
Thanks,
//richard
