Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739Ab1LVDre (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 22:47:34 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54423 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752983Ab1LVDrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 22:47:31 -0500
Date: Wed, 21 Dec 2011 19:45:26 -0800
From: Greg KH <gregkh@suse.de>
To: Tim Bird <tim.bird@am.sony.com>
Cc: linux-embedded <linux-embedded@vger.kernel.org>,
        linux kernel <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, john stultz <johnstul@us.ibm.com>,
        Brian Swetland <swetland@google.com>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>
Subject: Re: RFC: android logger feedback request
Message-ID: <20111222034526.GA14174@suse.de>
References: <4EF264C3.6000104@am.sony.com>
 <20111221231956.GB23859@suse.de>
 <4EF27B85.9080801@am.sony.com>
 <20111222005114.GA22541@suse.de>
 <4EF288B4.1070601@am.sony.com>
 <20111222014718.GA13085@suse.de>
 <4EF29217.7040408@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EF29217.7040408@am.sony.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 21, 2011 at 06:12:39PM -0800, Tim Bird wrote:
> Secondly, this is not a particularly new or radical interface. It is new
> to legacy Linux, but it's been in the Android Linux kernel for some years
> now, and it has worked well.

Sorry, but you know full well that is not a justification for _any_
chunk of code to be included in the main kernel tree.  Staging is fine,
but to add a new kernel/user api that looks at first glance, to merely
duplicate the existing in-kernel apis needs a very good explaination for
why it needs to be included.

greg k-h
