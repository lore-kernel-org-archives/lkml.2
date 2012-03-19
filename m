Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032404Ab2CSSON (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 14:14:13 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:36975 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030916Ab2CSSOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 14:14:12 -0400
Date: Mon, 19 Mar 2012 14:14:02 -0400 (EDT)
Message-Id: <20120319.141402.934377752041508724.davem@davemloft.net>
To: tytso@mit.edu
Cc: anca.emanuel@gmail.com, joe@perches.com, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/9] ext4: Use pr_fmt and pr_<level>
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120319161425.GB2502@thunk.org>
References: <20120319153133.GA2502@thunk.org>
	<CAJL_dMtC9fnOsY=4uDVJD=-h5u-qW=xjaf64gtDcgnKX2brhPw@mail.gmail.com>
	<20120319161425.GB2502@thunk.org>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 19 Mar 2012 11:14:05 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ted Ts'o" <tytso@mit.edu>
Date: Mon, 19 Mar 2012 12:14:25 -0400

> It's about the same utility as fixing "colour" to be "color" because
> people think standardized spelling is somehow critically important.
> Guess what?

Not the same, since moving to pr_*() allows us to standardize on
kernel log output formatting, amongst other things, so it has a real
practical impact unlike the spelling fix.

Ted, just fold the tent and raise the white flag, you're wrong on this
one.
