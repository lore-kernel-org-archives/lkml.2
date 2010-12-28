Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104Ab0L1HxH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 02:53:07 -0500
Received: from cantor.suse.de ([195.135.220.2]:39776 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751073Ab0L1HxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 02:53:04 -0500
Date: Mon, 27 Dec 2010 23:52:05 -0800
From: Greg KH <gregkh@suse.de>
To: Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>
Cc: linux-usb <linux-usb@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "Wang, Qi" <qi.wang@intel.com>, "Wang, Yong Y" <yong.y.wang@intel.com>,
        Andrew <andrew.chih.howe.khor@intel.com>,
        Intel OTC <joel.clark@intel.com>,
        "Ewe, Kok Howg" <kok.howg.ewe@intel.com>
Subject: Re: [PATCH] usb: pch_udc: Fixed issue which does not work with
 g_serial
Message-ID: <20101228075205.GA8411@suse.de>
References: <4D197433.2000800@dsn.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D197433.2000800@dsn.okisemi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 28, 2010 at 02:22:59PM +0900, Toshiharu Okada wrote:
> This patch fixes an issue which does not work with g_serial gadget.

What does that mean?  Please explain this better.

thanks,

greg k-h
