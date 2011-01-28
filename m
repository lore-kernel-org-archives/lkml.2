Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426Ab1A1HgI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 02:36:08 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34714 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529Ab1A1HgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 02:36:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=sts6fuQqMzuMkaP8cFGg7/Ds5G22WEu97CJe3xVwifh3sZZ0V1zvK5zOKboVMvFzbq
         Uj2Zzr0Oq14c0g6US3NhwkviS25QmG0liCMNHR3gi8tSN7j3Ni0Qn7W/hjhLIptmLk/V
         ajLOrABp3SmXmKlFf7QbrEB0OAWdQQ75pKcL4=
Date: Fri, 28 Jan 2011 10:35:54 +0300
From: Dan Carpenter <error27@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Vipin Mehta <vmehta@atheros.com>, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/15] staging: ath6kl: Update cfg80211 to recent
 calling convention changes
Message-ID: <20110128073554.GB20606@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Joe Perches <joe@perches.com>, Vipin Mehta <vmehta@atheros.com>,
	devel@driverdev.osuosl.org, Greg Kroah-Hartman <gregkh@suse.de>,
	linux-kernel@vger.kernel.org
References: <cover.1296186677.git.joe@perches.com>
 <9f92ccc5786180a9055ee22b28d1b6ea8cbda425.1296186677.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9f92ccc5786180a9055ee22b28d1b6ea8cbda425.1296186677.git.joe@perches.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 27, 2011 at 08:04:18PM -0800, Joe Perches wrote:
> Add bool unicast and bool multicast to set_default_key
> Return struct net_device * to add_virtual_intf

Don't we have to update the callers when we change the functions?  I
think this would break git bisect.  What am I missing?

regards,
dan carpenter

