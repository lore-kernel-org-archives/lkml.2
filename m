Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750805Ab1GFEBN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 00:01:13 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:52852 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750735Ab1GFEBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 00:01:12 -0400
X-Sasl-enc: EP9Z6C9UK80gkwRGKCKeTi7bbWqhzc69MVu6j+8BHXeD 1309924870
Date: Tue, 5 Jul 2011 21:01:06 -0700
From: Greg KH <greg@kroah.com>
To: Chris Forbes <chrisf@ijw.co.nz>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: staging: iio: adc: fix uninitialized use
Message-ID: <20110706040106.GA5232@kroah.com>
References: <1309657621-21711-1-git-send-email-chrisf@ijw.co.nz>
 <20110706033630.GA29391@kroah.com>
 <CAH3ygc2bEphf50oTxDjRNVNfLw96x5w5L88w2DVfAHOKgkEHRQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH3ygc2bEphf50oTxDjRNVNfLw96x5w5L88w2DVfAHOKgkEHRQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 06, 2011 at 03:57:53PM +1200, Chris Forbes wrote:
> Looks one of Dan Carpenter's patches in the staging-next tree -- f88af7e --
> already fixes this; disregard my patch.

Consider it disregarded.
