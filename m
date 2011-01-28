Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869Ab1A1Hlt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 02:41:49 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35964 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304Ab1A1Hls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 02:41:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=YdT4M7QB9bJGj8j/ILyWLs1cSRUUXxVlOwXdh+pRLGsDCg12R7cj48b3P6u7j0lnHu
         r2hyKAZjbiOVGlASAmCt96cUodpj5hSjzO2GHhcurnAr0sxJ41g3EcpqpIwbir0N1OC6
         iT/Sj6PZekh3h1n2ByMvAa3wxXrJtizLTVynI=
Date: Fri, 28 Jan 2011 10:41:37 +0300
From: Dan Carpenter <error27@gmail.com>
To: Joe Perches <joe@perches.com>, Vipin Mehta <vmehta@atheros.com>,
        devel@driverdev.osuosl.org, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/15] staging: ath6kl: Update cfg80211 to recent
 calling convention changes
Message-ID: <20110128074137.GC20606@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Joe Perches <joe@perches.com>, Vipin Mehta <vmehta@atheros.com>,
	devel@driverdev.osuosl.org, Greg Kroah-Hartman <gregkh@suse.de>,
	linux-kernel@vger.kernel.org
References: <cover.1296186677.git.joe@perches.com>
 <9f92ccc5786180a9055ee22b28d1b6ea8cbda425.1296186677.git.joe@perches.com>
 <20110128073554.GB20606@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110128073554.GB20606@bicker>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 28, 2011 at 10:35:54AM +0300, Dan Carpenter wrote:
> On Thu, Jan 27, 2011 at 08:04:18PM -0800, Joe Perches wrote:
> > Add bool unicast and bool multicast to set_default_key
> > Return struct net_device * to add_virtual_intf
> 
> Don't we have to update the callers when we change the functions?  I
> think this would break git bisect.  What am I missing?

Ah.  It didn't work before.  I see.

regards,
dan carpenter
