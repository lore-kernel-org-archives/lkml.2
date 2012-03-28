Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932461Ab2C1Rqb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 13:46:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:3181 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932259Ab2C1Rqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 13:46:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="122749262"
Message-ID: <4F734D0A.30904@linux.intel.com>
Date: Wed, 28 Mar 2012 10:40:26 -0700
From: J Freyensee <james_p_freyensee@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Null pointer dereference in pti_exit()
References: <20120326143059.GA4051@redhat.com>
In-Reply-To: <20120326143059.GA4051@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2012 07:31 AM, Stanislaw Gruszka wrote:
> Hi
>
> We have this bug report:
> https://bugzilla.redhat.com/show_bug.cgi?id=783561
>
> Crash when someone load module and do not have actual pti device.
> Then misc_deregister(&pti_char_driver) called from pti_exit() will be
> done without misc_register(&pti_char_driver), which is called from
> pti_pci_probe().
>
> It is not super critical issue since if somebody who do not have
> pti device have no reason to load modules, but I guess would be
> good to fix this.
>

Thanks for the email.  I just got back from a 3 month sabbatical so I am 
slowly getting back into the real world and how to be a computer engineer.

Yes, I am not sure why someone would want to configure their kernel to 
load a PTI module when there is not one on the platform to begin with. 
So that is a configuration problem of a user.  But I'll look at it and 
see if I think of anything; be a good exercise to re-jog my memory.

Thanks,
Jay

> Thanks
> Stanislaw


-- 
J (James/Jay) Freyensee
Storage Technology Group
Intel Corporation
