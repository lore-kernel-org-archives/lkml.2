Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716Ab2DWR2g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 13:28:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37603 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670Ab2DWR2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 13:28:33 -0400
Date: Mon, 23 Apr 2012 10:28:29 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, rob@landley.net, linux@arm.linux.org.uk,
        jic23@cam.ac.uk, swarren@nvidia.com, olof@lixom.net,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH V2 2/4] staging: iio: light: of: Fix vendor prefix of
 isl29018/isl29028
Message-ID: <20120423172829.GA2666@kroah.com>
References: <1335183097-21104-1-git-send-email-ldewangan@nvidia.com>
 <1335183097-21104-4-git-send-email-ldewangan@nvidia.com>
 <4F958E9F.8070402@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F958E9F.8070402@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2012 at 11:17:19AM -0600, Stephen Warren wrote:
> On 04/23/2012 06:11 AM, Laxman Dewangan wrote:
> > ISL29018/ISL29028 is from Intersil Corporation and making the
> > vendor prefix for this part as "isil" for OF compatibity.
> > 
> > Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> 
> I assume this patch will go through the staging tree. Let me know if you
> want me to take it through the Tegra tree.

Please take it through the Tegra tree, it is probably easier overall
that way:
	Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

