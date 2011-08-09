Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab1HIPfy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 11:35:54 -0400
Received: from cernmx30.cern.ch ([137.138.144.177]:59789 "EHLO
	CERNMX30.cern.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883Ab1HIPfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 11:35:52 -0400
Date: Tue, 9 Aug 2011 17:32:45 +0200
From: Manohar Vanga <manohar.vanga@cern.ch>
To: Martyn Welch <martyn.welch@ge.com>
CC: <gregkh@suse.de>, <cota@braap.org>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/8] staging: vme: rename *_slot_get to *_get_slot
Message-ID: <20110809153245.GA18479@becoht-mvanga>
Mail-Followup-To: Martyn Welch <martyn.welch@ge.com>, gregkh@suse.de,
	cota@braap.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
References: <1312194053-32310-1-git-send-email-manohar.vanga@cern.ch>
 <1312194053-32310-7-git-send-email-manohar.vanga@cern.ch>
 <4E369C26.5040300@ge.com>
 <20110801123121.GA7130@becoht-mvanga>
 <4E414FC0.8070700@ge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4E414FC0.8070700@ge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [137.138.192.18]
Keywords: CERN SpamKiller Note: -50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Martyn,

> The naming of the API is reasonably consistent at the moment. It looks like we
> aren't going to need to export vme_bus_get and vme_bus_put based on the
> conversation on patch 5. In addition to this, I've discovered that the
> functions for USB are actually called usb_get_dev and usb_put_dev, so the
> *_put/get convention isn't very strictly adhered to. I'd prefer to keep the
> API as is.

I guess it's not as strict. I'm dropping this one from the resend.

Thanks!

--
/manohar
