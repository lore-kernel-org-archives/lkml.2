Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936839Ab0COVUV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 17:20:21 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36803
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936799Ab0COVUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 17:20:19 -0400
Date: Mon, 15 Mar 2010 14:20:40 -0700 (PDT)
Message-Id: <20100315.142040.58983190.davem@davemloft.net>
To: isdn@linux-pingi.de
Cc: tilman@imap.cc, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       stable@vger.kernel.org, isdn4linux@listserv.isdn4linux.de,
       hjlipp@web.de, i4ldeveloper@listserv.isdn4linux.de
Subject: Re: [1/3] gigaset: avoid registering CAPI driver more than once
From: David Miller <davem@davemloft.net>
In-Reply-To: <1268664986.25524@pingi>
References: <1268664986.25524@pingi>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Karsten the way you reforward patches does not work.

And I've told you about this last time you submitted ISDN patches.

You don't add an extra "From: " line in the message body, so when the
patch gets applied the author gets set to _you_ instead of the person
who actually wrote the change.

All you're doing is ACK'ing this person's work, so simply reply to the
patch they posted and with your "Acked-by" line.  This way patchwork
and friends will figure out the rest when the patch gets integrated
into the net-2.6 tree.

By reposting the patches the way you are we're losing information.

Add to this the fact that you never have the time to properly take
care of ISDN patches, and when you do finally "get to it" you make all
kinds of submission errors.

This is not the first time either, it happens over and over again.
It's incredibly frustrating, especially for me.

Please seriously consider handing ISDN maintainership over to someone
who unlike you 1) has the time and the desire and 2) knows how to
submit patches properly.  Probably Tilman is the person who most meets
these criteria based upon what I've seen.

Meanwhile, I'm going to apply the original patches as posted by
Tilman so that the proper authorship gets set.
