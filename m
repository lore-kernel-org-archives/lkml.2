Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933789Ab0FCD3y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 23:29:54 -0400
Received: from gir.skynet.ie ([193.1.99.77]:58180 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933730Ab0FCD3x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 23:29:53 -0400
Date: Thu, 3 Jun 2010 04:29:35 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [git pull] drm updates
In-Reply-To: <alpine.DEB.2.00.1006030421120.21882@skynet.skynet.ie>
Message-ID: <alpine.DEB.2.00.1006030428230.21882@skynet.skynet.ie>
References: <alpine.DEB.2.00.1006030421120.21882@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Okay this isn't strictly all fixes, so pushback if you believe its too 
> much.

Oh and before you ask why it was recently rebased, I got two of the 
voltage fixes in the wrong order, so it broke bisection, so I just today 
reordered them.

Dave.
