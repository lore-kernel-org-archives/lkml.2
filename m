Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032338Ab2CSRx4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 13:53:56 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:36703 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964832Ab2CSRxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 13:53:54 -0400
Date: Mon, 19 Mar 2012 13:53:42 -0400 (EDT)
Message-Id: <20120319.135342.859237474072712585.davem@davemloft.net>
To: tytso@mit.edu
Cc: joe@perches.com, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/9] ext4: Use pr_fmt and pr_<level>
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120319153133.GA2502@thunk.org>
References: <20120319043420.GL31682@thunk.org>
	<20120319.011211.89954160788757412.davem@davemloft.net>
	<20120319153133.GA2502@thunk.org>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 19 Mar 2012 10:53:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ted Ts'o" <tytso@mit.edu>
Date: Mon, 19 Mar 2012 11:31:34 -0400

> And in the past we've always allowed for local variations of style;
> it's never been a strict style nazism.  Linus has always given
> maintainers latitude and has frowned on patch churn for churn's sake.

The variations in opinion and taste are why it's important for
us to discuss the interfaces and tweak them so that most people
are happy with them and then everyone uses them.

Your story about get_fs() still being around isn't a victory,
or an accomplishment, it's just a small failure that we've been
too lazy to fix.  But it's one that if someone did post a patch
for it, would be accepted.

And the thing you call churn, I call development and progress.

