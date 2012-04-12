Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761873Ab2DLCom (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 22:44:42 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:37244 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761859Ab2DLCok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 22:44:40 -0400
Date: Wed, 11 Apr 2012 20:44:39 -0600 (MDT)
From: Paul Walmsley <paul@pwsan.com>
To: Aneesh V <aneesh@ti.com>, Greg KH <greg@kroah.com>
cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, mgreer@animalcreek.com, msalter@redhat.com
Subject: Re: [PATCH v4 0/7] Add TI EMIF SDRAM controller driver
In-Reply-To: <1331934707-29487-1-git-send-email-aneesh@ti.com>
Message-ID: <alpine.DEB.2.00.1204112042070.29473@utopia.booyaka.com>
References: <1331934707-29487-1-git-send-email-aneesh@ti.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc Mark Greer, Mark Salter

Hi Greg, Aneesh,

On Sat, 17 Mar 2012, Aneesh V wrote:

> Add a driver for the EMIF SDRAM controller used in TI SoCs
> 
> EMIF is an SDRAM controller that supports, based on its revision,
> one or more of LPDDR2/DDR2/DDR3 protocols.This driver adds support
> for LPDDR2.

Just checking to see what the current state of this series is.  Greg, are 
you considering this for merging, or are there remaining issues?  Aneesh, 
do you have any remaining issues to resolve with this set?

This is useful not only for OMAP4 and AM3517/3505, but also will probably 
be useful for the C6x chips that Mark Salter is working on.


- Paul
