Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030321Ab2EKWZY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 18:25:24 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51145 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030292Ab2EKWZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 18:25:21 -0400
Date: Fri, 11 May 2012 15:25:17 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Hiroshi DOYU <hdoyu@nvidia.com>, linux-tegra@vger.kernel.org,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Benoit Cousson <b-cousson@ti.com>, Aneesh V <aneesh@ti.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] ARM: tegra20: Make MC optional in Kconfig
Message-ID: <20120511222517.GA4259@kroah.com>
References: <20120511095012.57f737d1b0d2536e0d367a9b@nvidia.com>
 <1336719389-28506-1-git-send-email-hdoyu@nvidia.com>
 <4FAD5255.1020908@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FAD5255.1020908@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 11:54:29AM -0600, Stephen Warren wrote:
> On 05/11/2012 12:56 AM, Hiroshi DOYU wrote:
> > For bare minimal system.
> > 
> > Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
> 
> Patches 1 and 2,
> 
> Acked-by: Stephen Warren <swarren@wwwdotorg.org>

Thanks, now applied.

greg k-h
