Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161622Ab2CPVni (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 17:43:38 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:36510 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964867Ab2CPVng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 17:43:36 -0400
X-Sasl-enc: sAD8qTGjUDYYJ/8Uk0L02nDJPYz/eIW5kLolA8lZkKZO 1331934215
Date: Fri, 16 Mar 2012 14:43:34 -0700
From: Greg KH <greg@kroah.com>
To: Aneesh V <aneesh@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH v4] misc: ddr: add LPDDR2 data from JESD209-2
Message-ID: <20120316214334.GA24925@kroah.com>
References: <1331929177-11694-1-git-send-email-aneesh@ti.com>
 <1331931007-584-1-git-send-email-aneesh@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331931007-584-1-git-send-email-aneesh@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 17, 2012 at 02:20:07AM +0530, Aneesh V wrote:
> add LPDDR2 data from the JEDEC spec JESD209-2. The data
> includes:
> 
> 1. Addressing information for LPDDR2 memories of different
>    densities and types(S2/S4)
> 2. AC timing data.
> 
> This data will useful for memory controller device drivers.
> Right now this is used by the TI EMIF SDRAM controller
> driver.
> 
> Cc: Greg KH <greg@kroah.com>
> Signed-off-by: Aneesh V <aneesh@ti.com>

What happened to the other patches that depended on this one?

greg k-h
