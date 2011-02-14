Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678Ab1BNROV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 12:14:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65408 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753662Ab1BNROT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 12:14:19 -0500
Subject: Re: [PATCH 2/2 v2] pci: use security_capable() when checking
 capablities during config space read
From: Eric Paris <eparis@redhat.com>
To: Chris Wright <chrisw@sous-sol.org>
Cc: James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Don Dutile <ddutile@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-pci@vger.kernel.org
In-Reply-To: <20110210235856.GD9869@sequoia.sous-sol.org>
References: <1297318312-14309-1-git-send-email-chrisw@sous-sol.org>
	 <1297318312-14309-3-git-send-email-chrisw@sous-sol.org>
	 <alpine.LRH.2.00.1102101915000.20298@tundra.namei.org>
	 <20110210235856.GD9869@sequoia.sous-sol.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Feb 2011 12:14:01 -0500
Message-ID: <1297703641.2783.4.camel@unknown001a4b0c2895>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-10 at 15:58 -0800, Chris Wright wrote:
> * James Morris (jmorris@namei.org) wrote:
> > What about these other users of cap_raised?
> > 
> > drivers/block/drbd/drbd_nl.c:   if (!cap_raised(nsp->eff_cap, CAP_SYS_ADMIN)) {
> > drivers/md/dm-log-userspace-transfer.c: if (!cap_raised(nsp->eff_cap, CAP_SYS_ADMIN))
> > drivers/staging/pohmelfs/config.c:      if (!cap_raised(nsp->eff_cap, CAP_SYS_ADMIN))
> > drivers/video/uvesafb.c:        if (!cap_raised(nsp->eff_cap, CAP_SYS_ADMIN))
> 
> Those are a security_netlink_recv() variant.  They should be converted
> although makes sense as a different patchset.
> 
> > Also, should this have a reported-by for Eric ?
> 
> Yes it should, thanks.  Below is patch with Reported-by added (seemed
> overkill to respin the series; holler if that's perferred).

ACKed-by: Eric Paris <eparis@redhat.com>

on both of them.

-eric

