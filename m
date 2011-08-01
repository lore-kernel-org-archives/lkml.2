Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869Ab1HAMeY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 08:34:24 -0400
Received: from cernmx30.cern.ch ([137.138.144.177]:33754 "EHLO
	CERNMX30.cern.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab1HAMeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 08:34:18 -0400
Date: Mon, 1 Aug 2011 14:31:21 +0200
From: Manohar Vanga <manohar.vanga@cern.ch>
To: Martyn Welch <martyn.welch@ge.com>
CC: <gregkh@suse.de>, <cota@braap.org>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/8] staging: vme: rename *_slot_get to *_get_slot
Message-ID: <20110801123121.GA7130@becoht-mvanga>
Mail-Followup-To: Martyn Welch <martyn.welch@ge.com>, gregkh@suse.de,
	cota@braap.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
References: <1312194053-32310-1-git-send-email-manohar.vanga@cern.ch>
 <1312194053-32310-7-git-send-email-manohar.vanga@cern.ch>
 <4E369C26.5040300@ge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4E369C26.5040300@ge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [137.138.192.18]
Keywords: CERN SpamKiller Note: -50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Martyn,

> If your doing vme_slot_get, then there's also vme_lm_get, vme_master_get and
> vme_slave_get.
> 
> Doing just this would then lead to more inconsistency in the naming and
> wouldn't even get rid of all the functions using the *_get naming convention.

I can simply change those as well and resend :)

> I'm not sure this change is worth it.

I thought it would be worth changing this especially with the addition of bridge
refcounting functions (which have the *_get/_set convention).

--
/manohar
