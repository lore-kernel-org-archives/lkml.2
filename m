Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736Ab0D1TGw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 15:06:52 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60120 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756627Ab0D1TGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 15:06:50 -0400
Message-ID: <4BD8873F.5050807@infradead.org>
Date: Wed, 28 Apr 2010 16:06:39 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Wouter Van Rooy <wouter.vanrooy@gmail.com>
Subject: Re: linux-next: manual merge of the staging-next tree with the v4l-dvb
 tree
References: <20100428160749.52da847a.sfr@canb.auug.org.au> <20100428152641.GD4483@kroah.com>
In-Reply-To: <20100428152641.GD4483@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Wed, Apr 28, 2010 at 04:07:49PM +1000, Stephen Rothwell wrote:
>> Hi Greg,
>>
>> Today's linux-next merge of the staging-next tree got a conflict in
>> drivers/staging/cx25821/cx25821-alsa.c between commit
>> 4e0c923a0d23f86c7331b32bc2aeb280e10e029e ("V4L/DVB: Staging: cx25821: fix
>> coding style issues in cx25821-alsa.c") from the v4l-dvb tree and commit
>> 98a178beaaf4c9a0acc4815807be51425b91f0a7 ("Staging: cx25821 fixed C99
>> comments, white spaces and unnecessary braces") from the staging-next
>> tree.
>>
>> I used the v4l-dvb versions of the conflicting bits (they looked neater
>> to me).
> 
> Odd, Mauro, why are you applying coding style fixes to the staging tree
> to your tree?  I'll be glad to take them instead.

This driver (cx25821) came from my tree, so I was just keep maintaining it.
Although the driver works fine, it has some coding style issues, but the biggest
issue is that it has the same code that is almost identical replicated 8
times (one for each simultaneous stream that the device supports), and another
code duplicated 4 times (for the 4 simultaneous output streams).

Sorry, but I didn't realized that you're also retrieving patches for it. I think
I just assumed that we're following the same procedure as agreed with relation
to go7007 driver.

Anyway, the driver maintainer is now preparing a changeset that will hopefully 
solve the remaining issues that prevented it to be added directly on /drivers/media.

Cheers,
Mauro
