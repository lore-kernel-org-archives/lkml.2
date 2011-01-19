Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366Ab1ASNHV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 08:07:21 -0500
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:39144 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754293Ab1ASNHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 08:07:20 -0500
Date: Wed, 19 Jan 2011 18:30:50 +0530
From: "G, Manjunath Kondaiah" <manjugk@ti.com>
To: Govindraj <govindraj.ti@gmail.com>
Cc: Thomas Weber <weber@corscience.de>, linux-omap@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>,
        "Govindraj.R" <govindraj.raja@ti.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Andrei Emeltchenko <andrei.emeltchenko@nokia.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] OMAP: Enable Magic SysRq on serial console ttyOx
Message-ID: <20110119130049.GB9365@m-desktop>
References: <1295426461-12459-1-git-send-email-weber@corscience.de>
 <AANLkTin0-joNuqxqL79j0wqPk_A5mtAgzEY=X=PeH=+C@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTin0-joNuqxqL79j0wqPk_A5mtAgzEY=X=PeH=+C@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 19, 2011 at 03:01:39PM +0530, Govindraj wrote:
> On Wed, Jan 19, 2011 at 2:11 PM, Thomas Weber <weber@corscience.de> wrote:
> > Magic SysRq key is not working for OMAP on new serial
> > console ttyOx because SUPPORT_SYSRQ is not defined
> > for omap-serial.
> >
> > This patch defines SUPPORT_SYSRQ in omap-serial and
> > enables handling of Magic SysRq character.
> >
> > Signed-off-by: Thomas Weber <weber@corscience.de>
> 
> Looks fine to me.
> 
> Acked-by: Govindraj.R <govindraj.raja@ti.com>
I tried to use SysRq key on minicom after applying this patch, it looks
like it is not triggering sysrq event.

Am I missing anything?

-Manjunath
