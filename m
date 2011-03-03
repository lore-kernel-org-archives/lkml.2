Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195Ab1CCHUl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 02:20:41 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49227 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753960Ab1CCHUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 02:20:36 -0500
Date: Thu, 3 Mar 2011 10:20:30 +0300
From: Stanislav Fomichev <kernel@fomichev.me>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, Randy Dunlap <randy.dunlap@oracle.com>,
        driverdevel <devel@driverdev.osuosl.org>, gregkh@suse.de,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] staging/brcm80211: fix printk format warnings
Message-ID: <20110303072028.GA21427@sdf-MacBook>
Mail-Followup-To: Stephen Rothwell <sfr@canb.auug.org.au>,
	Greg KH <greg@kroah.com>, Randy Dunlap <randy.dunlap@oracle.com>,
	driverdevel <devel@driverdev.osuosl.org>, gregkh@suse.de,
	linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <20110301181119.f1c7a9c3.sfr@canb.auug.org.au>
 <20110301162948.34c28d6e.randy.dunlap@oracle.com>
 <20110302210511.GA20798@kroah.com>
 <20110303103620.6b3c463f.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110303103620.6b3c463f.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Maybe due to conflict resolutions in my tree (assuming that Randy based
> his patch in linux-next).
We don't have brcm80211/sys/ directory (it was renamed to
brcm80211/brcmsmac); so it's based on the wrong/outdated tree.

And I suppose these errors are already fixed.
