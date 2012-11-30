Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558Ab2K3Bsp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 20:48:45 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33771 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754838Ab2K3Bso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 20:48:44 -0500
Date: Thu, 29 Nov 2012 17:48:40 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, Jaehoon Chung <jh80.chung@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, Chris Ball <cjb@laptop.org>
Subject: Re: [PATCH 053/270] mmc: sdhci-s3c: fix the wrong number of max bus
 clocks
Message-ID: <20121130014840.GE13478@kroah.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
 <1353949160-26803-54-git-send-email-herton.krzesinski@canonical.com>
 <1354028413.4266.53.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354028413.4266.53.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 03:00:13PM +0000, Ben Hutchings wrote:
> On Mon, 2012-11-26 at 14:55 -0200, Herton Ronaldo Krzesinski wrote:
> > 3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Jaehoon Chung <jh80.chung@samsung.com>
> > 
> > commit 5feb54a1ab91a237e247c013b8c4fb100ea347b1 upstream.
> > 
> > We can use up to four bus-clocks; but on module remove, we didn't
> > disable the fourth bus clock.
> > 
> > Signed-off-by: Jaehoon Chung <jh80.chung@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > Signed-off-by: Chris Ball <cjb@laptop.org>
> > Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
> 
> This is missing from 3.4 and 3.6 (but not 3.2); it apparently needed its
> context adjusted.

Thanks, now backported.

greg k-h
