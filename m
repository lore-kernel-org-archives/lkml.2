Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161721Ab1FAJSx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 05:18:53 -0400
Received: from claranet-outbound-smtp05.uk.clara.net ([195.8.89.38]:35158 "EHLO
	claranet-outbound-smtp05.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751625Ab1FAJSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 05:18:50 -0400
X-Greylist: delayed 2135 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Jun 2011 05:18:50 EDT
From: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [kernel.org users] Turning off the incremental diff robot
Date: Wed, 1 Jun 2011 09:43:11 +0100
User-Agent: KMail/1.13.7 (Linux/2.6.38.6; KDE/4.6.2; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <4DE3E9E7.8020008@zytor.com> <20110531195201.GB7995@1wt.eu>
In-Reply-To: <20110531195201.GB7995@1wt.eu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106010943.11180.tvrtko.ursulin@onelan.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, May 30, 2011 at 12:03:03PM -0700, H. Peter Anvin wrote:
> Hi all,
> 
> With the v3.0 name change I was looking over what might break, and I'm
> seriously considering turning off the incremental diff robot on
> kernel.org.  It's not clear to me that it is actually useful anymore,
> with git and all.
> 
> Do anyone actually use these anymore?

I use them to go from one stable version to the next and it is quite 
convenient. Maybe there is another way to achieve that (that "all" in "git and 
all")?

Thanks,

Tvrtko
