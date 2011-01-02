Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750854Ab1ABGUR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 01:20:17 -0500
Received: from void.printf.net ([89.145.121.20]:36191 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750695Ab1ABGUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 01:20:15 -0500
Date: Sun, 2 Jan 2011 06:20:13 +0000
From: Chris Ball <cjb@laptop.org>
To: Will Newton <will.newton@gmail.com>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-mmc@vger.kernel.org, Matt Fleming <matt@console-pimps.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4] dw_mmc: Add Synopsys DesignWare mmc host driver.
Message-ID: <20110102062013.GB18668@void.printf.net>
References: <AANLkTi=0RtvsGX+Q3goL3mdG6oKeNidYtiudTZ8ZTpRP@mail.gmail.com> <20101208115510.GD10998@console-pimps.org> <AANLkTi=KqOa-MRQiptCtZGvoafRCgULfE3QFs=hmGpdi@mail.gmail.com> <AANLkTi=PpTi1_JO9Q=ph7w9Jim8iXMf9LbCfmEkWuo-h@mail.gmail.com> <20101209064751.GA21128@void.printf.net> <AANLkTimMgrawcndvUTYYjq9BGFqs-sbRsZkwVQ0Uvhvb@mail.gmail.com> <20101209160157.GA28586@void.printf.net> <AANLkTim3Rj2tTbqvT8nM4L=p=Wx8bdOnGq=EDv+cs02g@mail.gmail.com> <20101211192320.GA24430@void.printf.net> <AANLkTik7cMwgwXR1zK44HXC+1YtzpU3_zW2GUjcBMi8X@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTik7cMwgwXR1zK44HXC+1YtzpU3_zW2GUjcBMi8X@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Will,

On Thu, Dec 16, 2010 at 05:04:36PM +0000, Will Newton wrote:
> This adds the mmc host driver for the Synopsys DesignWare mmc
> host controller, found in a number of embedded SoC designs.
> 
> Signed-off-by: Will Newton <will.newton@imgtec.com>

Thanks, I've pushed this to mmc-next for .38 now after adding:

Reviewed-by: Matt Fleming <matt@console-pimps.org>
Reviewed-by: Chris Ball <cjb@laptop.org>

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
