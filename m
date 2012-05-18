Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946852Ab2ERXJX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 19:09:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:62470 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946814Ab2ERXJS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 19:09:18 -0400
MIME-Version: 1.0
In-Reply-To: <CAFLxGvzZ_YJS25wK=YHCELwJOZZuhdeoB6S5Yw_TMVEXzTofOg@mail.gmail.com>
References: <1337284200-1838-1-git-send-email-auke-jan.h.kok@intel.com>
	<CAFLxGvzZ_YJS25wK=YHCELwJOZZuhdeoB6S5Yw_TMVEXzTofOg@mail.gmail.com>
Date: Fri, 18 May 2012 16:09:15 -0700
Message-ID: <CABsxX9JWK1qVubuYt0+HoZy-Lhz0kp6a3MxyT7ny5YzLS2rMJQ@mail.gmail.com>
Subject: Re: [PATCH] Trace event for capable().
From: "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Paris <eparis@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 3:33 PM, richard -rw- weinberger
<richard.weinberger@gmail.com> wrote:
>
> On Thu, May 17, 2012 at 9:50 PM, Auke Kok <auke-jan.h.kok@intel.com>
> wrote:
> > Add a simple trace event for capable().
> >
> > There's been a lot of discussion around capable(), and there
> > are plenty of tools to help reduce capabilities' usage from
> > userspace. A major gap however is that it's almost impossible
> > to see or verify which bits are requested from either userspace
> > or in the kernel.
> >
> > This patch adds a minimal tracer that will print out which
> > CAPs are requested and whether the request was granted.
>
> Can we please have support for user namespaces?
> At least idicate whether the current namespace is init_user_ns or not.

that was the main reason for sending this out already - that should be
trivial to add to the trace event, but I haven't looked at namespaces
yet myself. I'll check it out.

Auke
