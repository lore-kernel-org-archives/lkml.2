Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932750Ab2DZAtp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 20:49:45 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:55366 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932704Ab2DZAto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 20:49:44 -0400
Date: Wed, 25 Apr 2012 20:48:17 -0400 (EDT)
Message-Id: <20120425.204817.1783721275395887649.davem@davemloft.net>
To: jrnieder@gmail.com
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, sam@ravnborg.org,
        mmarek@suse.cz
Subject: Re: [ 30/62] Fix modpost failures in fedora 17
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120426004131.GA8556@burratino>
References: <20120424223305.GA7748@kroah.com>
	<20120424223244.539071890@linuxfoundation.org>
	<20120426004131.GA8556@burratino>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 25 Apr 2012 17:48:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonathan Nieder <jrnieder@gmail.com>
Date: Wed, 25 Apr 2012 19:41:32 -0500

> I haven't tested this, but I suspect 3.0.y has the same problem ---
> v3.3-rc1~66^2~12 ("modpost: use a table rather than a giant if/else
> statement") just clarified the code a little and does not seem to have
> gone wrong.
> 
> In other words, the conflict encountered when applying this to 3.0.y
> looks like a textual and not a meaningful one.  Backport follows.

This is %100 correct.
