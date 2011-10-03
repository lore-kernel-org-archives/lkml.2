Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756407Ab1JCPDP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 11:03:15 -0400
Received: from cernmx32.cern.ch ([137.138.144.178]:29569 "EHLO
	CERNMX32.cern.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756389Ab1JCPDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 11:03:11 -0400
Date: Mon, 3 Oct 2011 16:59:24 +0200
From: Manohar Vanga <manohar.vanga@cern.ch>
To: <gregkh@suse.de>
CC: <martyn.welch@ge.com>, <cota@braap.org>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] [RESEND v6] VME Framework Fixes
Message-ID: <20111003145924.GA16136@becoht-mvanga>
Mail-Followup-To: gregkh@suse.de, martyn.welch@ge.com, cota@braap.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <1317029238-13357-1-git-send-email-manohar.vanga@cern.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1317029238-13357-1-git-send-email-manohar.vanga@cern.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [137.138.192.18]
Keywords: CERN SpamKiller Note: -50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Martyn,

Can you review these patches and let me know if any other changes need to
be made?

Thanks!

On Mon, Sep 26, 2011 at 11:27:14AM +0200, Manohar Vanga wrote:
> Hi,
> 
> I start by apologizing for my absence recently as I was away on vacation
> for a few weeks. Picking up where I left off, this is the resend of the
> two final patches along with some movement of code into additional patches.
> 
> Martyn, Emilio: Thanks for all the feedback :-)
> 
> Thanks!
> Manohar
> 
> Manohar Vanga (4):
>   staging: vme: add struct vme_dev for VME devices
>   staging: vme: make match() driver specific to improve non-VME64x
>     support
>   staging: vme: get rid of struct vme_device_id and slots
>   staging: vme_user: rename USER_BUS_MAX to VME_USER_BUS_MAX
> 
>  drivers/staging/vme/devices/vme_user.c |   67 +++-----
>  drivers/staging/vme/devices/vme_user.h |    2 +-
>  drivers/staging/vme/vme.c              |  284 +++++++++++++++-----------------
>  drivers/staging/vme/vme.h              |   50 ++++--
>  drivers/staging/vme/vme_api.txt        |   90 ++++++-----
>  drivers/staging/vme/vme_bridge.h       |    6 +-
>  6 files changed, 246 insertions(+), 253 deletions(-)
> 
> -- 
> 1.7.4.1
> 

-- 
/manohar
