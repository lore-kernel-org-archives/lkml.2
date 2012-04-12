Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934203Ab2DLNKv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 09:10:51 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:44454 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752380Ab2DLNKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 09:10:49 -0400
X-Sasl-enc: xoGtc2sprXhgzdZOSehw2xeOHp9VfwzoH3JaCatzoUlN 1334236247
Date: Thu, 12 Apr 2012 06:10:45 -0700
From: Greg KH <greg@kroah.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Paul Walmsley <paul@pwsan.com>, Aneesh V <aneesh@ti.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, mgreer@animalcreek.com, msalter@redhat.com
Subject: Re: [PATCH v4 0/7] Add TI EMIF SDRAM controller driver
Message-ID: <20120412131045.GB31384@kroah.com>
References: <1331934707-29487-1-git-send-email-aneesh@ti.com>
 <alpine.DEB.2.00.1204112042070.29473@utopia.booyaka.com>
 <20120412030044.GA26236@kroah.com>
 <4F867A95.9030104@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F867A95.9030104@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 12:17:49PM +0530, Santosh Shilimkar wrote:
> I was hoping that we will have some thing like drivers/memory/*
> but since it doesn't exist, we used drivers/misc.

Why not create it?  I have no objection to that, it makes it more
obvious as to what this really is.

greg k-h
