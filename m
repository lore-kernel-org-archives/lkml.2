Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752396Ab0KDQHV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 12:07:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44588 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368Ab0KDQHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 12:07:16 -0400
Date: Thu, 4 Nov 2010 09:03:21 -0700
From: Greg KH <gregkh@suse.de>
To: samu.p.onkalo@nokia.com
Cc: hmh@hmh.eng.br, alan@linux.intel.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysfs: device-core: sysfs open close notify
Message-ID: <20101104160321.GB3631@suse.de>
References: <1288861417-469-1-git-send-email-samu.p.onkalo@nokia.com> <20101104132339.GC10390@suse.de> <62697B07E9803846BC582181BD6FB6B836EB63CB54@NOK-EUMSG-02.mgdnok.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62697B07E9803846BC582181BD6FB6B836EB63CB54@NOK-EUMSG-02.mgdnok.nokia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 04, 2010 at 02:32:15PM +0100, samu.p.onkalo@nokia.com wrote:
> It is easy to get rid of if the mode parameter is used to pass the information
> that this entry uses open_close_notify.  What do you think, is it ok to use
> mode also to that purpose?

Don't try to overload a parameter that has been used for the past 40+
years in one way, to try to add additional side-band data that has
nothing to do with it.

That way lies madness.

thanks,

greg k-h
