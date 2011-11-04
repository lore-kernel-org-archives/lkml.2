Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117Ab1KDGJq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 02:09:46 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:51465 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880Ab1KDGJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 02:09:44 -0400
Date: Fri, 04 Nov 2011 02:09:19 -0400 (EDT)
Message-Id: <20111104.020919.1596634708556929724.davem@davemloft.net>
To: ben@decadent.org.uk
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [005/107] sparc: Allow handling signals when stack is
 corrupted.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1320381208.3079.61.camel@deadeye>
References: <20111102221600.GA26650@kroah.com>
	<20111102221450.536525065@clark.kroah.org>
	<1320381208.3079.61.camel@deadeye>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 03 Nov 2011 23:09:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>
Date: Fri, 04 Nov 2011 04:33:28 +0000

> But is there a real application that needs this?

You get zero debugging information when this happens so without
this change analysis of a crash is virtually impossible.
