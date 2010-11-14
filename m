Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561Ab0KNUPa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 15:15:30 -0500
Received: from ns1.siteground211.com ([209.62.36.12]:44960 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969Ab0KNUP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 15:15:29 -0500
Subject: Re: [RFC/PATCH] usb: Add streams support to epautoconf.
From: Felipe Balbi <me@felipebalbi.com>
To: Greg KH <greg@kroah.com>
Cc: Maya Erez <merez@codeaurora.org>, linux-usb@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Mike Frysinger <vapier@gentoo.org>, Cliff Cai <cliff.cai@analog.com>,
        Michal Nazarewicz <m.nazarewicz@samsung.com>,
        Fabien Chouteau <fabien.chouteau@barco.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101114182915.GA20922@kroah.com>
References: <1289715812-29000-1-git-send-email-merez@codeaurora.org>
	 <20101114182915.GA20922@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 14 Nov 2010 22:15:33 +0200
Message-ID: <1289765733.15533.4.camel@eowin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, 2010-11-14 at 10:29 -0800, Greg KH wrote:
> > +	if (USB_ENDPOINT_XFER_BULK == type) {
> 
> Ick, no, don't do comparisons like this.  The compiler will let you know
> if you acidentally get it wrong with only one '=' character, don't do
> things "backward" like this just to work around stupid compilers.

we actually have helpers for this and usb_endpoint_xfer_bulk(desc)
would do it.

-- 
balbi

