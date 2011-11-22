Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758733Ab1KVVpa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 16:45:30 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34940 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757378Ab1KVVp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 16:45:29 -0500
Date: Tue, 22 Nov 2011 16:44:39 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: David Miller <davem@davemloft.net>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2011-11-22
Message-ID: <20111122214438.GG8452@tuxdriver.com>
References: <20111122.151429.253381379981773726.davem@davemloft.net>
 <20111122205655.GE8452@tuxdriver.com>
 <20111122.160511.2302883259439708995.davem@davemloft.net>
 <20111122.161322.454163033398038634.davem@davemloft.net>
 <4ECC1479.8090209@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ECC1479.8090209@lwfinger.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 03:30:33PM -0600, Larry Finger wrote:
> On 11/22/2011 03:13 PM, David Miller wrote:
> >From: David Miller<davem@davemloft.net>
> >Date: Tue, 22 Nov 2011 16:05:11 -0500 (EST)

> >Everyone can just return IRQ_HANDLED and everything would just work.
> >
> >But you know that's not the case, and that it's important that this value
> >is returned accurately.
> 
> I was trying to find the thread that reported the improvement in
> performance with this change, but failed. Is it possible that their
> change just papered over an interrupt storm from some other device
> that shared that interrupt?

Original patch was posted here:

	http://marc.info/?l=linux-wireless&m=132143811916674&w=2

And the Red Hat Bugzilla entry is here:

	https://bugzilla.redhat.com/show_bug.cgi?id=658451

> I'm following this because the rtlwifi-family of drivers already did
> what was suggested here. If this is wrong, then so is it.

Sounds like that nees to be fixed...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
