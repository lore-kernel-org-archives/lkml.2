Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933083Ab1IBBzp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 21:55:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:32368 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933019Ab1IBBzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 21:55:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="44351314"
Subject: Re: [PATCH] EFI: Revert "x86: Serialize EFI time accesses on
 rtc_lock"
From: Zhang Rui <rui.zhang@intel.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: "jbeulich@novell.com" <jbeulich@novell.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, jwboyer@gmail.com
In-Reply-To: <1314878535.8038.32.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1314844576.26340.10.camel@rui>
	 <1314878535.8038.32.camel@mfleming-mobl1.ger.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 Sep 2011 09:55:35 +0800
Message-ID: <1314928535.15006.5.camel@rui>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-01 at 20:02 +0800, Matt Fleming wrote:
> On Thu, 2011-09-01 at 10:36 +0800, Zhang Rui wrote:
> > My kernel freezes during boot with the following log.
> > I'm not sure what the problem is, but reverting 
> > ef68c8f87ed13f65df867dddf36c0e185b27b942 does help.
> 
> I already posted a fix for this, https://lkml.org/lkml/2011/8/30/253
> 
Oh, that's great. Sorry for the noise. :)

thanks,
rui

