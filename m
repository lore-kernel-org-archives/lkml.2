Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757406Ab0LIVn6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 16:43:58 -0500
Received: from cantor.suse.de ([195.135.220.2]:42279 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757311Ab0LIVn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 16:43:56 -0500
Date: Thu, 9 Dec 2010 13:43:47 -0800
From: Greg KH <gregkh@suse.de>
To: Dave Hansen <dave@sr71.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Brett Rudley <brudley@broadcom.com>,
        Henry Ptasinski <henryp@broadcom.com>, Nohee Ko <noheek@broadcom.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Mike Rapoport <mike.rapoport@gmail.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: brcm80211 hangs when disabling wireless
Message-ID: <20101209214347.GA15172@suse.de>
References: <1291930010.7960.30.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291930010.7960.30.camel@nimitz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 09, 2010 at 01:26:50PM -0800, Dave Hansen wrote:
> I've been getting hard hangs when I toggle the wireless on a Lenovo
> S10-3.  It happens both with the physical switch and the Fn-F5 key
> combo.  It's quite repeatable.  The system is quite stable when I'm not
> trying to disable the wireless, though.

What kernel version is this?

Linus's latest tree has a known bug when the wireless is suspended and
then resumed.  Broadcom is working on it but no patch is forthcoming
yet.  Perhaps this is the same issue.

thanks,

greg k-h
