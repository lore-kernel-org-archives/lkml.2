Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711Ab2CTBqn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 21:46:43 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40745 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616Ab2CTBqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 21:46:42 -0400
Date: Tue, 20 Mar 2012 01:46:33 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Ted Ts'o" <tytso@mit.edu>, Joe Perches <joe@perches.com>,
        David Miller <davem@davemloft.net>, anca.emanuel@gmail.com,
        adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/9] ext4: Use pr_fmt and pr_<level>
Message-ID: <20120320014633.GJ6589@ZenIV.linux.org.uk>
References: <20120319153133.GA2502@thunk.org>
 <CAJL_dMtC9fnOsY=4uDVJD=-h5u-qW=xjaf64gtDcgnKX2brhPw@mail.gmail.com>
 <20120319161425.GB2502@thunk.org>
 <20120319.141402.934377752041508724.davem@davemloft.net>
 <20120319183126.GA6031@thunk.org>
 <1332182773.3908.11.camel@joe2Laptop>
 <20120320010401.GA14363@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120320010401.GA14363@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2012 at 09:04:01PM -0400, Ted Ts'o wrote:

> Yes, but we can't do structured notifications with the current
> pr_<foo>.  So why change literally tens of thousands of callsites when
> in order to really realize the full promise of structured
> notifications, we'll have to change them *again*?

Two words: commit count.

Al, expecting a rant from mingo about inexcusable hostility to new
duhvelopers any time now...
