Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756994Ab0JEUHc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 16:07:32 -0400
Received: from kroah.org ([198.145.64.141]:52989 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756696Ab0JEUHa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 16:07:30 -0400
Date: Tue, 5 Oct 2010 13:07:20 -0700
From: Greg KH <greg@kroah.com>
To: "Savoy, Pavan" <pavan_savoy@ti.com>
Cc: "gregkh@suse.de" <gregkh@suse.de>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] prepare TI_ST to move out of staging
Message-ID: <20101005200720.GB4228@kroah.com>
References: <1285877610-3043-1-git-send-email-pavan_savoy@ti.com>
 <20101005184925.GA20825@kroah.com>
 <19F8576C6E063C45BE387C64729E739404AA21CB25@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19F8576C6E063C45BE387C64729E739404AA21CB25@dbde02.ent.ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 06, 2010 at 12:40:33AM +0530, Savoy, Pavan wrote:
> Along with Bluetooth, we have some FM V4L2 patches which are being
> reviewed and re-submitted to the linux-media list, we will bring in
> them, once the linux-media ACKs them.
> 
> They are intended for staging too, since there are few conflicts with
> other patches posted, I suppose it should be alright for them to go
> into the linux-next via your staging-next since the linux-media trees
> lags behind linux-next.

If you get an ack from the media maintainers, I can gladly take them.

thanks,

greg k-h
