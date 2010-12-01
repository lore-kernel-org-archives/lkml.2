Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595Ab0LAT2M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 14:28:12 -0500
Received: from smtp.nokia.com ([147.243.1.47]:36178 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755642Ab0LAT2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 14:28:11 -0500
From: Felipe Contreras <felipe.contreras@nokia.com>
Subject: Re: [PATCHv5 0/4] omap: iovmm - fixes for iovmm module
To: Hiroshi.DOYU@nokia.com, x0095840@ti.com, h-kanigeri2@ti.com
Cc: tony@atomide.com, linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
In-Reply-To: <20101129.104729.97149649.Hiroshi.DOYU@nokia.com>
References: <1288033806-1496-1-git-send-email-x0095840@ti.com> <20101129.104729.97149649.Hiroshi.DOYU@nokia.com>
User-Agent: notmuch 0.4-75-gd52f68c
Message-ID: <1291231567-notmuch-felipe.contreras@nokia.com>
Date: Wed, 01 Dec 2010 21:27:39 +0200
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hiroshi.DOYU@nokia.com wrote:
> From: ext Fernando Guzman Lugo <x0095840@ti.com>
> Subject: [PATCHv5 0/4] omap: iovmm - fixes for iovmm module
> Date: Mon, 25 Oct 2010 21:10:02 +0200
> 
> > Version 5:
> > * Changes in "iommu: create new api to set valid da range"
> >   - Change range variables to platform data structure.
> 
> Acked-by: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>

Does that means you are going to send a pull request with these for .38?

Fernando, is there a branch where you have all the changes needed in
tidspbridge?

I guess the only patch missing would be the one for linux-arm.

Cheers.

-- 
Felipe Contreras
