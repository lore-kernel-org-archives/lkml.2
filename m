Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756364Ab2JCVbe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 17:31:34 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:48756 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754984Ab2JCVbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 17:31:32 -0400
Date: Wed, 3 Oct 2012 23:31:28 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: paulmck@linux.vnet.ibm.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] make CONFIG_EXPERIMENTAL invisible and default
Message-ID: <20121003213117.GD637@somewhere>
References: <20121002195042.GA16087@www.outflux.net>
 <20121003132538.GE13192@linux.vnet.ibm.com>
 <20121003161702.GA22008@kroah.com>
 <20121003164712.GF2527@linux.vnet.ibm.com>
 <CAGXu5jJhEpdwCqYc0hWs504snMZg9FMygUjLwRUSyaKGAfXb5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jJhEpdwCqYc0hWs504snMZg9FMygUjLwRUSyaKGAfXb5Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2012 at 11:43:32AM -0700, Kees Cook wrote:
> I would expect a simple addition of "this is dangerous/buggy" to the
> description and "default n" is likely the way to go for that kind of
> thing.

Agreed.

> I think the history of CONFIG_EXPERIMENTAL has proven there
> isn't a sensible way to create a global flag for this kind of thing.
> To paraphrase Serge: my experimental options are not your experimental
> options.
> For example, some of the things that already had the experimental
> config removed, they left the "(EXPERIMENTAL)" in their config title.

Right.
