Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923Ab0LMKXJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 05:23:09 -0500
Received: from sd-11162.dedibox.fr ([88.191.70.230]:37144 "EHLO
	sd-11162.dedibox.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568Ab0LMKXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 05:23:07 -0500
X-Greylist: delayed 385 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Dec 2010 05:23:07 EST
Date: Mon, 13 Dec 2010 11:16:38 +0100
From: Stelian Pop <stelian@popies.net>
To: Michael Hanselmann <public@hansmi.ch>
Cc: Jean Delvare <khali@linux-fr.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 20/30] macintosh/ams: don't use flush_scheduled_work()
Message-ID: <20101213101638.GA2188@calypso>
Reply-To: Stelian Pop <stelian@popies.net>
Mail-Followup-To: Stelian Pop <stelian@popies.net>,
	Michael Hanselmann <public@hansmi.ch>,
	Jean Delvare <khali@linux-fr.org>, Tejun Heo <tj@kernel.org>,
	linux-kernel@vger.kernel.org
References: <1292086307-19211-1-git-send-email-tj@kernel.org>
 <1292086307-19211-21-git-send-email-tj@kernel.org>
 <20101211201931.00414518@endymion.delvare>
 <AANLkTinUko5JfbYTOVujXEKqBHfdSXuqAmVcphWZyOrU@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinUko5JfbYTOVujXEKqBHfdSXuqAmVcphWZyOrU@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 12, 2010 at 02:37:28PM +0100, Michael Hanselmann wrote:

> On Sat, Dec 11, 2010 at 8:19 PM, Jean Delvare <khali@linux-fr.org> wrote:
> > On Sat, 11 Dec 2010 17:51:37 +0100, Tejun Heo wrote:
> >> flush_scheduled_work() is deprecated and scheduled to be removed.
> >> Directly flush ams_info.worker on detach instead.
> >
> > The AMS driver is maintained by Stelian Pop and Michael Hanselmann
> > according to MAINTAINERS. I am Cc'ing them both.
> 
> Change looks good to me, but can't test due to lack of hardware.

Same here. Looks like this driver can be orphaned...

Stelian.
-- 
Stelian Pop <stelian@popies.net>
