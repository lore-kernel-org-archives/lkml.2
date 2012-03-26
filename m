Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab2CZItd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 04:49:33 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:53617 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666Ab2CZItc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 04:49:32 -0400
Message-ID: <1332751768.3511.3.camel@jlt3.sipsolutions.net>
Subject: Re: [PATCH 4/4] compat: add some tracing backport work
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        lf_driver_backport@lists.linux-foundation.org
Date: Mon, 26 Mar 2012 10:49:28 +0200
In-Reply-To: <CAB=NE6XXd-T5B37Cc_eCwnWHRk-_UVn0JY0mQjzMQcK+ZcLuWQ@mail.gmail.com> (sfid-20120322_053002_038310_D468A77C)
References: <1332214021-9716-1-git-send-email-mcgrof@frijolero.org>
	 <1332214021-9716-5-git-send-email-mcgrof@frijolero.org>
	 <1332245766.3329.14.camel@jlt3.sipsolutions.net>
	 <CAB=NE6XyDDfzu71K-1ecMQ+F-0Z1iTN4OKCUjJ+E3yxvydks0Q@mail.gmail.com>
	 <CAB=NE6XXd-T5B37Cc_eCwnWHRk-_UVn0JY0mQjzMQcK+ZcLuWQ@mail.gmail.com>
	 (sfid-20120322_053002_038310_D468A77C)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-21 at 21:29 -0700, Luis R. Rodriguez wrote:

> But no dice. I then figured it may be my kernel with
> CONFIG_TRACEPOINTS=y and indeed that is the case -- so we have to
> consider the case where the target kernel may have tracing enabled and
> we have to disable it somehow. Undef'ing CONFIG_TRACEPOINTS and
> DECLARE_TRACE doesn't really do it.

Oh, ok, yuck. So I guess we can't easily disable tracing if it's enabled
in the base kernel ...

> We may need to redefine each macro to some COMPAT_TRACE_ macro, not sure yet.

That would require patches again though, no fun either.

johannes

