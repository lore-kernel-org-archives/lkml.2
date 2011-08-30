Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282Ab1H3Kmw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 06:42:52 -0400
Received: from cernmx30.cern.ch ([137.138.144.177]:46511 "EHLO
	CERNMX30.cern.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057Ab1H3Kmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 06:42:49 -0400
Date: Tue, 30 Aug 2011 12:39:29 +0200
From: Manohar Vanga <manohar.vanga@cern.ch>
To: "Emilio G. Cota" <cota@braap.org>
CC: <gregkh@suse.de>, <martyn.welch@ge.com>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] staging: vme: make match() driver specific to
 improve non-VME64x support
Message-ID: <20110830103929.GA8814@becoht-mvanga>
Mail-Followup-To: "Emilio G. Cota" <cota@braap.org>, gregkh@suse.de,
	martyn.welch@ge.com, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
References: <1314608570-32766-1-git-send-email-manohar.vanga@cern.ch>
 <1314608570-32766-4-git-send-email-manohar.vanga@cern.ch>
 <20110829145543.GA9952@flamenco.cs.columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110829145543.GA9952@flamenco.cs.columbia.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [137.138.192.18]
Keywords: CERN SpamKiller Note: -50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Here there seems to be a missing kfree(vdev), like the one after device_unregister()
> a few lines earlier.

> > +	if (!err & (drv->ndev == 0))
> 
> Probably you meant if (!err && drv->ndev == 0) here.

Ah darn. Will fix and resend.

> In fact one could imagine a driver that has no devices when it's
> installed (it might get them later); so I'd remove this check.

Yeah I suppose with VME64x it's possible. Will remove.

-- 
/manohar
