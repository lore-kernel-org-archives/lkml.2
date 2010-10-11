Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619Ab0JKOxb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 10:53:31 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:58808 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754387Ab0JKOxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 10:53:30 -0400
Subject: Re: get_maintainer
From: Johannes Berg <johannes@sipsolutions.net>
To: Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1286808293.3416.18.camel@Joe-Laptop>
References: <1286789815.3634.5.camel@jlt3.sipsolutions.net>
	 <1286808293.3416.18.camel@Joe-Laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Oct 2010 16:53:29 +0200
Message-ID: <1286808809.3634.64.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

> Pull this in some test branch and try it out.
> 
> git://repo.or.cz/linux-2.6/get_maintainer.git 20100922_gm
> 
> If you try this and find it less than adequate,
> please tell me why.

> Here's a couple of recent longish threads about this.
> http://lkml.org/lkml/2010/9/10/94
> http://lkml.org/lkml/2010/9/25/184

Oh my, I missed that.

I tried it out, and it seems --git is no longer default. That in itself
will probably help lots already, and somebody using non-default options
will hopefully pay more attention.

Thanks!

Johannes

