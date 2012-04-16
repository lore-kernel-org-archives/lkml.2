Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787Ab2DPNWO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 09:22:14 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:34777 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753663Ab2DPNWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 09:22:12 -0400
Date: Mon, 16 Apr 2012 15:21:56 +0200
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/13] edac: Create a dimm struct and move the labels
 into it
Message-ID: <20120416132156.GB308@aftab>
References: <1333039546-5590-1-git-send-email-mchehab@redhat.com>
 <1333039546-5590-2-git-send-email-mchehab@redhat.com>
 <20120330105048.GA30876@aftab>
 <4F8BDB3D.2020808@redhat.com>
 <20120416110222.GA308@aftab>
 <4F8C0628.5020104@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F8C0628.5020104@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 08:44:40AM -0300, Mauro Carvalho Chehab wrote:
> Because this will make patch 5/13 even bigger and messy. Each of those
> loops have different functions: the first one initializes the legacy API
> data structures for virtual csrows/channels, while the second one 
> initializes the struct that contains the real DIMM or rank information.
> 
> Patches 1 to 4 are just a preparation for patch 5/13, cleaning what's
> possible before the big change.
> 
> While it is possible to do the above merge on this patch alone, such
> cleanup doesn't make sense at the patch series (and should be reverted
> on patch 5/13 anyway), as what we want is to separate the DIMM information 
> on a data structure that won't mix it with a memory layout-dependent 
> information, as not all drivers use csrows/channels.

So what?!

Does that mean we do patches in between other patches where code quality
is not that good simply because we'll remove that in the later patch?
No!

Also, 5/13 is a monster and needs proper splitting anyway. So, if you
have a strong technical reason to do two loops, please come forward with
it. Otherwise, please change your patches to review requirements as
_everyone_ else does on lkml instead of giving some unrelated and bogus
reasoning for this and that.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
