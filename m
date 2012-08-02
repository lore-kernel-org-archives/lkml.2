Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520Ab2HBK4J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 06:56:09 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:48494 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527Ab2HBK4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 06:56:07 -0400
Date: Thu, 2 Aug 2012 03:56:01 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Karsten Keil <isdn@linux-pingi.de>, Joe Perches <joe@perches.com>,
        "open list:ISDN SUBSYSTEM" <netdev@vger.kernel.org>
Subject: Re: [PATCH] isdnloop: fix and simplify isdnloop_init()
Message-ID: <20120802105601.GA2765@kroah.com>
References: <20120802040158.GA11860@localhost>
 <20120802104456.GA21537@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120802104456.GA21537@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2012 at 06:44:56PM +0800, Fengguang Wu wrote:
> [Add more CC]

That's not going to do much, you just sent them a patch they can't apply
without editing by hand :(
