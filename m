Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133Ab3ACD2x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 22:28:53 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:47519 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861Ab3ACD2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 22:28:51 -0500
Date: Wed, 02 Jan 2013 19:28:48 -0800 (PST)
Message-Id: <20130102.192848.1391048999163570664.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, sony.chacko@qlogic.com,
        sucheta.chakraborty@qlogic.com, sritej.velaga@qlogic.com
Subject: Re: linux-next: build failure after merge of the final tree
 (net-next tree related)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130103142353.b4fee0ccd57730e4fbd63ba9@canb.auug.org.au>
References: <20130103142353.b4fee0ccd57730e4fbd63ba9@canb.auug.org.au>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 3 Jan 2013 14:23:53 +1100

> Caused by commit 13159183ec7a ("qlcnic: 83xx base driver") from the
> net-next tree.  Why is this commit adding a function that already exists
> globally?

And this is after I pushed back on this patch series 5 times or so.

You qlogic guys, can you see why I give you such a hard time with
your patch submissions?  Even after I ask you to correct all of the
most obvious problems, there is still garbage like this that shows
up in your changes.

What in the world do I have to do, other than push back on your
submissions even harder, to keep crap like this from happening
in the future?

Tell me.

You, as a group, are the absolute worst networking driver submitters.

This is a real problem because you submit large bodies of code that 1)
nobody wants to review and 2) has a very small user base.  So you
impart an extremely large burdon upon me, in particular, because I'm
the only person that actually reviews your code at all.
