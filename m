Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab1HCOJd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 10:09:33 -0400
Received: from cernmx30.cern.ch ([137.138.144.177]:5040 "EHLO CERNMX30.cern.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753511Ab1HCOJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 10:09:28 -0400
Date: Wed, 3 Aug 2011 16:06:30 +0200
From: Manohar Vanga <manohar.vanga@cern.ch>
To: Martyn Welch <martyn.welch@ge.com>
CC: <gregkh@suse.de>, <cota@braap.org>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/8] staging: vme: add functions for bridge module
 refcounting
Message-ID: <20110803140630.GA29460@becoht-mvanga>
Mail-Followup-To: Martyn Welch <martyn.welch@ge.com>, gregkh@suse.de,
	cota@braap.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
References: <1312194053-32310-1-git-send-email-manohar.vanga@cern.ch>
 <1312194053-32310-6-git-send-email-manohar.vanga@cern.ch>
 <4E39555C.30507@ge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4E39555C.30507@ge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [137.138.192.18]
Keywords: CERN SpamKiller Note: -50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Martyn,

> Can we not do this inside vme_master_request, vme_slave_request, etc?
> 
> I.e. Add reference count when resources are given out.
> 
> This would then be done in the vme_*_free routines.

I agree this would be much better. I will change this and resend :)

Thanks!
--
/manohar
