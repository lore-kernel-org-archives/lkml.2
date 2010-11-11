Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599Ab0KKWfl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 17:35:41 -0500
Received: from claranet-outbound-smtp02.uk.clara.net ([195.8.89.35]:37843 "EHLO
	claranet-outbound-smtp02.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752835Ab0KKWfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 17:35:39 -0500
X-Greylist: delayed 1969 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Nov 2010 17:35:39 EST
Message-ID: <4CDC67FF.3010006@sciolus.org>
Date: Thu, 11 Nov 2010 22:02:39 +0000
From: "R.M. Thomas" <rmthomas@sciolus.org>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, gregkh@suse.de
Subject: Re: [PATCH -next] staging/easycap: make module params private/static,
 fix build
References: <20101111125655.15fa7188.sfr@canb.auug.org.au> <20101111104422.28594510.randy.dunlap@oracle.com>
In-Reply-To: <20101111104422.28594510.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> The easycap driver has module parameters (bars, gain, & debug)
> with global scope that intrude on the kernel namespace and cause
> build problems.  Change the names of them to be driver-specific
> and make 2 of them static.

I did do test builds of the driver in-tree prior to submitting the
recent set of patches, but did not see any warnings so did not spot
this mistake.  There's presumably something wrong with the way I'm
building the kernel.

Thanks,
Mike
