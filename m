Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759915Ab2BJSvV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 13:51:21 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:37543 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759901Ab2BJSvD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 13:51:03 -0500
Message-ID: <1328899861.14197.7.camel@joe2Laptop>
Subject: Re: [Cocci] Re: [PATCH] scripts/coccinelle/misc/boolinit.cocci:
 semantic patch for bool issues
From: Joe Perches <joe@perches.com>
To: dedekind1@gmail.com
Cc: Julia Lawall <Julia.Lawall@lip6.fr>, Michal Marek <mmarek@suse.cz>,
        Gilles Muller <Gilles.Muller@lip6.fr>, bruce.w.allan@intel.com,
        rusty@rustcorp.com.au, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, cocci@diku.dk,
        Julia Lawall <julia@diku.dk>
Date: Fri, 10 Feb 2012 10:51:01 -0800
In-Reply-To: <1328899454.22240.91.camel@sauron.fi.intel.com>
References: <1328893887-28932-1-git-send-email-Julia.Lawall@lip6.fr>
	 <1328895943.14197.1.camel@joe2Laptop>
	 <1328899454.22240.91.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-02-10 at 20:44 +0200, Artem Bityutskiy wrote:
> On Fri, 2012-02-10 at 09:45 -0800, Joe Perches wrote:
> > On Fri, 2012-02-10 at 18:11 +0100, Julia Lawall wrote:
> > > From: Julia Lawall <Julia.Lawall@lip6.fr>
> > Thanks Julia.  It seems to work well.
> I wonder though, why would we want to change if (a == true) with if (a)
> etc? Julia did not provide the explanation in the commit message but
> referred to you and Rusty in the semantic patch.

Testing booleans against specific values is poor form.
booleans should be tested or !tested.

If you are going to submit these patches,
I suggest you break them out by 2nd level
directory.

patch 1: drivers/foo/...
patch 2: drivers/bar/...
...
patch n: drivers/baz/...

and cc: trivial@kernel.org

