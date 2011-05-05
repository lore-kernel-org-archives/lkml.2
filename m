Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130Ab1EEVye (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 17:54:34 -0400
Received: from kroah.org ([198.145.64.141]:48478 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297Ab1EEVyc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 17:54:32 -0400
Date: Thu, 5 May 2011 14:34:58 -0700
From: Greg KH <greg@kroah.com>
To: Valdis.Kletnieks@vt.edu
Cc: Kay Sievers <kay.sievers@vrfy.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] reboot: disable usermodehelper to prevent fs access
Message-ID: <20110505213458.GA4331@kroah.com>
References: <1304595126.1284.3.camel@zag>
 <39558.1304630665@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <39558.1304630665@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 05, 2011 at 05:24:25PM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Thu, 05 May 2011 13:32:05 +0200, Kay Sievers said:
> 
> > In case CONFIG_UEVENT_HELPER_PATH is not set to "", which it
> > should be on every system
> 
> If it indeed should be that on every system, shouldn't it be listed
> in feature-removal-schedule.txt?

It's the default value, but distros, and people, can and do override it
for various reasons.  Why would it be added to
feature-removal-schedule.txt?

> Does anybody have a running list of "Stuff we set by default at one time, but
> no longer recommend"?

Look at the default values for different configurations options and why
they differ in your system is about the only way that I know of, sorry.

thanks,

greg k-h
