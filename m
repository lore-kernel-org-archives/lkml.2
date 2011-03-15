Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab1COWYu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 18:24:50 -0400
Received: from mail2.microsoft.com ([131.107.115.215]:42734 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597Ab1COWYn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 18:24:43 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@suse.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: RE: [PATCH 00/12] Staging: hv: Cleanup vmbus driver - Phase II
Thread-Topic: [PATCH 00/12] Staging: hv: Cleanup vmbus driver - Phase II
Thread-Index: AQHL410m1bVkW5tVfEmy8hHweSC+VpQu9SEg
Date: Tue, 15 Mar 2011 22:24:41 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E048019A87@TK5EX14MBXC128.redmond.corp.microsoft.com>
References: <1300226527-26933-1-git-send-email-kys@microsoft.com>
 <20110315220454.GC30390@suse.de>
In-Reply-To: <20110315220454.GC30390@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.123.12]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@suse.de]
> Sent: Tuesday, March 15, 2011 6:05 PM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> virtualization@lists.osdl.org
> Subject: Re: [PATCH 00/12] Staging: hv: Cleanup vmbus driver - Phase II
> 
> On Tue, Mar 15, 2011 at 03:02:07PM -0700, K. Y. Srinivasan wrote:
> > This patch-set fixes the following issues in the vmbus driver (vmbus_drv.c):
> 
> <snip>
> 
> Thanks for the patches, but as the .39 merge window is closed, I'll be
> holding on to these until after .39-rc1 is out before I can do anything
> with them.
> 
> So don't be surprised if I don't respond to them for a few weeks.  Don't
> worry, they aren't lost. :)

If possible, I would love to get your feedback even if you cannot check 
in these patches. Also, if you can give me feedback as to what else
would need to be fixed to exit staging  as far as the vmbus driver is 
concerned, I can work on those over the next couple of weeks
until the tree opens up. If it is ok with you we will send the
DPRINT cleanup patches in the next couple of days.
 
Regards,

K. Y

