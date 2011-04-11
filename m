Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160Ab1DKVp1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 17:45:27 -0400
Received: from kroah.org ([198.145.64.141]:42860 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756039Ab1DKVpZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 17:45:25 -0400
Date: Mon, 11 Apr 2011 14:38:36 -0700
From: Greg KH <greg@kroah.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, stable@kernel.org,
        Matti Aaltonen <matti.j.aaltonen@nokia.com>,
        Mauro <mchehab@infradead.org>, lkml <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org
Subject: Re: [stable] [PATCH] media/radio/wl1273: fix build errors
Message-ID: <20110411213836.GA25899@kroah.com>
References: <20110227095154.2741d051.randy.dunlap@oracle.com>
 <AANLkTikQ3k_E1-7Hnxdgm1xRo4Q+Skw_-Yn_T4K35D2V@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikQ3k_E1-7Hnxdgm1xRo4Q+Skw_-Yn_T4K35D2V@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 31, 2011 at 08:09:57PM -0400, Mike Frysinger wrote:
> On Sun, Feb 27, 2011 at 12:51, Randy Dunlap wrote:
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> >
> > RADIO_WL1273 needs to make sure that the mfd core is built to avoid
> > build errors:
> >
> > ERROR: "mfd_add_devices" [drivers/mfd/wl1273-core.ko] undefined!
> > ERROR: "mfd_remove_devices" [drivers/mfd/wl1273-core.ko] undefined!
> 
> 2.6.38 stable worthy ?
> 
> now in mainline as 1b149bbe9156d2eb2afd5a072bd61ad0d4bfaca7 ...

Now queued up, thanks.

greg k-h
