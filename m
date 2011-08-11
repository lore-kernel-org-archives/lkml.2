Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751308Ab1HKQ0s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 12:26:48 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:45442 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738Ab1HKQ0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 12:26:46 -0400
Date: Thu, 11 Aug 2011 18:26:39 +0200
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        EDAC devel <linux-edac@vger.kernel.org>, X86-ML <x86@kernel.org>,
        "Petkov, Borislav" <Borislav.Petkov@amd.com>
Subject: Re: [PATCH] EDAC: Correct Kconfig dependencies
Message-ID: <20110811162639.GH11442@aftab>
References: <4E41055F.9010900@redhat.com>
 <1312980210-3692-1-git-send-email-bp@amd64.org>
 <20110810101429.5a8f36e9.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110810101429.5a8f36e9.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 01:14:29PM -0400, Randy Dunlap wrote:
> On Wed, 10 Aug 2011 14:43:30 +0200 Borislav Petkov wrote:
> 
> > From: Borislav Petkov <borislav.petkov@amd.com>
> > 
> > Both AMD and Intel i7 EDAC drivers use MCE features and are thus
> > dependent of this functionality present in the kernel. Express this in
> > Kconfig so that randconfig builds don't break.
> > 
> > Reported-by: Randy Dunlap <rdunlap@xenotime.net>
> > Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> 
> Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Mauro, can you apply this to your

git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/edac.git linux_next

Linus picked it up prematurely but it should go through your tree along
with the rest of the changes.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
