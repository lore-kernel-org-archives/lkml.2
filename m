Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751668Ab1BSHEG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 02:04:06 -0500
Received: from kroah.org ([198.145.64.141]:35503 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977Ab1BSHEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 02:04:04 -0500
Date: Fri, 18 Feb 2011 23:03:58 -0800
From: Greg KH <greg@kroah.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Naveen Singh <Naveen.Singh@atheros.com>, Jack Yang <Jack.Yang@atheros.com>,
        Samuel Chang <Samuel.Chang@atheros.com>, Joe Perches <joe@perches.com>,
        Jerry Hu <Jerry.Hu@atheros.com>,
        Maggie Huang <Maggie.Huang@atheros.com>,
        Vipin Mehta <Vipin.Mehta@atheros.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        mcgrof@gmail.com
Subject: Re: ath6kl - coordination of development
Message-ID: <20110219070358.GA3871@kroah.com>
References: <20110219013001.GM15610@tux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110219013001.GM15610@tux>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 18, 2011 at 05:30:01PM -0800, Luis R. Rodriguez wrote:
> Joe -- I know you have a large series pending, but perhaps we can
> coordinate to only send batches in 20 ? Or Greg do you have any preference?

20 sounds reasonable, if not pushing it a bit.  Let's start with that
and see how it goes.  If they apply cleanly, and are easy to review,
maybe we can do more the next round.

thanks,

greg k-h
