Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555Ab0EFB7L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 21:59:11 -0400
Received: from mail.perches.com ([173.55.12.10]:1935 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011Ab0EFB7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 21:59:09 -0400
Subject: RE: [PATCH 1/1] staging: hv: Add Time Sync feature to hv_utils
 module
From: Joe Perches <joe@perches.com>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
       "gregkh@suse.de" <gregkh@suse.de>,
       Hank Janssen <hjanssen@microsoft.com>
In-Reply-To: <1FB5E1D5CA062146B38059374562DF72662A6F52@TK5EX14MBXC130.redmond.corp.microsoft.com>
References: <1FB5E1D5CA062146B38059374562DF72662A6D3B@TK5EX14MBXC130.redmond.corp.microsoft.com>
	 ,<1273107494.1735.87.camel@Joe-Laptop.home>
	 <1FB5E1D5CA062146B38059374562DF72662A6F52@TK5EX14MBXC130.redmond.corp.microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 May 2010 18:59:07 -0700
Message-ID: <1273111147.1735.90.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-06 at 01:42 +0000, Haiyang Zhang wrote:
> > Why a maximum of 50 samples?
> After reboot the flag ICTIMESYNCFLAG_SYNC is included in the 
> first time message after the timesync channel is opened. Since the 
> hv_utils module is loaded after hv_vmbus, the first message is usually
> missed. The other thing is, systime is automatically set to emulated 
> hardware clock which may not be UTC time or the same time 
> zone. So, to override these effects, we use the first 50 time samples 
> for initial system time setting.

I suggest putting that in a commit message or a code comment.

cheers, Joe


