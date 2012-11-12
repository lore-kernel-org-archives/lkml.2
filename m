Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163Ab2KLXTQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 18:19:16 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:58856 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752718Ab2KLXTP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 18:19:15 -0500
Message-ID: <1352762356.18715.23.camel@joe-AO722>
Subject: Re: [PATCH] checkpatch: warn about using CONFIG_EXPERIMENTAL
From: Joe Perches <joe@perches.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 12 Nov 2012 15:19:16 -0800
In-Reply-To: <CAGXu5jLyWv6jN_iQ+NvDMy5f2o_AN2eJTQGpOzshB3VSnL1pOg@mail.gmail.com>
References: <20121112225019.GA23718@www.outflux.net>
	 <1352761583.18715.16.camel@joe-AO722>
	 <CAGXu5jLyWv6jN_iQ+NvDMy5f2o_AN2eJTQGpOzshB3VSnL1pOg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-11-12 at 15:11 -0800, Kees Cook wrote:
> On Mon, Nov 12, 2012 at 3:06 PM, Joe Perches <joe@perches.com> wrote:
> > On Mon, 2012-11-12 at 14:50 -0800, Kees Cook wrote:
> >> +                     WARN("CONFIG_EXPERIMENTAL",
> >> +                          "Use of CONFIG_EXPERIMENTAL is deprecated. " +
> >> +                          "For alternatives, see " +
> >> +                          "https://lkml.org/lkml/2012/10/23/580\n");
> >
> > I'd much prefer this be on a single line and not using the +
> > string operator as that style is not currently used in checkpatch.
> 
> Hah. Okay. We should exclude checkpatch.pl from the 80 character check
> it warns about. ;)

;)

checkpatch is for .[ch] files, it isn't for anything else really.


