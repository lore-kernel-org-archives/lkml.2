Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238Ab1ASWGv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 17:06:51 -0500
Received: from ixqw-mail-out.ixiacom.com ([66.77.12.12]:13574 "EHLO
	ixqw-mail-out.ixiacom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701Ab1ASWGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 17:06:50 -0500
Message-ID: <4D376079.8020108@ixiacom.com>
Date: Wed, 19 Jan 2011 14:06:49 -0800
From: Earl Chew <echew@ixiacom.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: "Hans J. Koch" <hjk@hansjkoch.de>
CC: Greg KH <greg@kroah.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: RFC: UIO  null parent for __uio_register_device and uio_device_name()
References: <4D366104.1000400@ixiacom.com> <20110119145619.GA17399@local> <4D370654.7020400@ixiacom.com> <20110119163005.GA12979@kroah.com> <4D371A35.5000009@ixiacom.com> <20110119205243.GC17399@local>
In-Reply-To: <20110119205243.GC17399@local>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hans Koch wrote:
> There's a small library with helper functions. Among other things, they
> allow searching the UIO device node by name (the name you gave your device
> in uio_info->name). The library is here:
> 
> git://git.linutronix.de/projects/libUIO.git
> 
> or with gitweb:
> 
> http://git.linutronix.de/gitweb.cgi?p=projects/libUIO.git;a=summary

Hans, Greg,

I appreciate the chance to discuss this change with you. I do understand your
point of view, and I can see how libUIO navigates sysfs from userspace
to figure out what's there.

Unfortunately I am not in a position to mandate the inclusion of sysfs in our
deployment, and Linux UIO has a dependency on sysfs to be usable.

I had hoped to stay within the confines of the mainline, but for now
we'll have to tolerate a local patch.

Earl
