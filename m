Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921Ab1KIQmV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 11:42:21 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37893 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751201Ab1KIQmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 11:42:20 -0500
Date: Wed, 9 Nov 2011 16:42:12 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Vinod Koul <vinod.koul@linux.intel.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, greg@kroah.com,
        linux-kernel@vger.kernel.org
Subject: Re: Staging clear up
Message-ID: <20111109164211.GA4016@opensource.wolfsonmicro.com>
References: <20111108211656.29defdda@lxorguk.ukuu.org.uk>
 <20111109121329.GC21630@sirena.org.uk>
 <1320854413.32205.948.camel@vkoul-udesk3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320854413.32205.948.camel@vkoul-udesk3>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 09, 2011 at 09:30:13PM +0530, Vinod Koul wrote:

> Alan, if you folks are not using the staging driver I am okay for its
> removal

Someone will need to fix the build breakage from peering at the headers
from staging.
