Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504Ab2BMHYD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 02:24:03 -0500
Received: from senator.holtmann.net ([87.106.208.187]:37861 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875Ab2BMHYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 02:24:00 -0500
Message-ID: <1329117706.28848.55.camel@aeonflux>
Subject: Re: [PATCH 1/2] bluetooth: Use more current logging styles
From: Marcel Holtmann <marcel@holtmann.org>
To: Joe Perches <joe@perches.com>
Cc: "Gustavo F. Padovan" <padovan@profusion.mobi>,
        "David S. Miller" <davem@davemloft.net>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Date: Mon, 13 Feb 2012 08:21:46 +0100
In-Reply-To: <1329115573.30878.1.camel@joe2Laptop>
References: <cover.1329102581.git.joe@perches.com>
	 <44b8744770a55924c68f8ad0ca274816d2d6148f.1329102581.git.joe@perches.com>
	 <1329114913.28848.50.camel@aeonflux> <1329115573.30878.1.camel@joe2Laptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

> > Why is this a good thing?
> 
> It's more similar to the rest of the <foo>_<level> uses.
> Other than that, it's a little smaller.
> 
> > And in your patch we have bt_err not having \n\n in the end.
> 
> There shouldn't be a newline at all with the
> actual functions bt_err or bt_info except
> at the uses.

then you might wanna read your patch again ;)

> This is the style used in pr_<level> so that
> it becomes possible to use pr_cont.

Since we don't have a bt_cont, I don't see why bother changing this
right now.

Regards

Marcel


