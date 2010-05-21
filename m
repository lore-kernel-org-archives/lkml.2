Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934496Ab0EUS74 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 14:59:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49683 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934442Ab0EUS7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 14:59:50 -0400
Date: Fri, 21 May 2010 11:56:39 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Airlie <airlied@linux.ie>
cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [git pull] drm for 2.6.35-rc1 (revised)
In-Reply-To: <alpine.DEB.2.00.1005210718460.16929@skynet.skynet.ie>
Message-ID: <alpine.LFD.2.00.1005211154120.3689@i5.linux-foundation.org>
References: <alpine.DEB.2.00.1005190310010.1205@skynet.skynet.ie> <alpine.DEB.2.00.1005210718460.16929@skynet.skynet.ie>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Grrr. Not well tested. On x86, I get several warnings like this:

	drivers/video/fbmem.c: In function ¡fb_do_apertures_overlap¢:
	drivers/video/fbmem.c:1494: warning: format ¡%llx¢ expects type ¡long long unsigned int¢, but argument 2 has type ¡resource_size_t¢

Please fix. And please test the thing. 

I suspect we should have some "new warnings are errors" thing for 
linux-next, so that people can't do this.

		Linus
