Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823Ab0K2GHg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 01:07:36 -0500
Received: from foo.birdnet.se ([213.88.146.6]:54149 "HELO foo.stuge.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751160Ab0K2GHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 01:07:35 -0500
Message-ID: <20101129060732.5130.qmail@stuge.se>
Date: Mon, 29 Nov 2010 07:07:32 +0100
From: Peter Stuge <peter@stuge.se>
To: ath9k-devel@venema.h4ckr.net, linux-kernel@vger.kernel.org
Subject: Re: [ath9k-devel] [PATCH wireless-next] ath: Rename ath_print to
	ath_debug
Mail-Followup-To: ath9k-devel@lists.ath9k.org, linux-kernel@vger.kernel.org
References: <5febb0e1fba0ec2bb77f6ade8b251ba0edf4614c.1290988277.git.joe@perches.com> <AANLkTinc251WbwuLqFbOZ5ipNGZW7=wub3DoWwy42=+e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinc251WbwuLqFbOZ5ipNGZW7=wub3DoWwy42=+e@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luis R. Rodriguez wrote:
> On Sun, Nov 28, 2010 at 3:53 PM, Joe Perches <joe@perches.com> wrote:
> > Make the function name match the function purpose.
> > ath_debug is a debug only facility.
> > ath_print seems too generic a name for a debug only use.
> 
> Nack, I don't see the point.

The point is to improve readability. I like the patch.


//Peter
