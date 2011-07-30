Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899Ab1G3Vek (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 17:34:40 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:59809 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681Ab1G3Ved (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 17:34:33 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Greg Dietsche <gregory.dietsche@cuw.edu>
Subject: Re: [PATCH] uvcvideo: correct kernel version reference
Date: Sat, 30 Jul 2011 23:34:38 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.37-gentoo-r3; KDE/4.6.5; x86_64; ; )
Cc: mchehab@infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, trivial@kernel.org,
        jpiszcz@lucidpixels.com
References: <alpine.DEB.2.02.1107301020220.4925@p34.internal.lan> <201107302236.13354.laurent.pinchart@ideasonboard.com> <4E347824.9080207@cuw.edu>
In-Reply-To: <4E347824.9080207@cuw.edu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201107302334.38723.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Saturday 30 July 2011 23:31:16 Greg Dietsche wrote:
> On 07/30/2011 03:36 PM, Laurent Pinchart wrote:
> > Hi Greg,
> > 
> > Thanks for the patch.
> > 
> > On Saturday 30 July 2011 17:47:30 Greg Dietsche wrote:
> >> change from v2.6.42 to v3.2
> > 
> > This patch would be queued for v3.2. As the code it fixes will go away at
> > the same time, it would be pretty pointless to apply it :-) Thanks for
> > warning me though.
> 
> you're welcome - I thought the merge window was still open for 3.1 ...
> so that's why I sent it in.

Linus' merge window is still open, but this will have to go through Mauro's 
tree, and it won't make it on time.

-- 
Regards,

Laurent Pinchart
