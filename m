Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759379Ab2EINZK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 09:25:10 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:49936 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757560Ab2EINZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 09:25:08 -0400
Date: Wed, 9 May 2012 15:24:55 +0200
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>,
        Greg K H <gregkh@linuxfoundation.org>
Subject: Re: [EDAC ABI v13 09/25] edac: rewrite the sysfs code to use struct
 device
Message-ID: <20120509132455.GE22737@aftab.osrc.amd.com>
References: <1334608729-30803-1-git-send-email-mchehab@redhat.com>
 <1334608729-30803-10-git-send-email-mchehab@redhat.com>
 <20120509123441.GC22737@aftab.osrc.amd.com>
 <4FAA6CC9.5060106@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FAA6CC9.5060106@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 10:10:33AM -0300, Mauro Carvalho Chehab wrote:
> This is fixed by this patch, already acked-by Greg:
> 	[EDAC ABI v13 17/25] edac: Create a per-Memory Controller bus
> 	http://git.infradead.org/users/mchehab/edac.git/commit/a2c90149c2e87e51908003b1ba504f92d749f74b
> 
> Basically, on devices with multiple controllers, there a separate per-memory controller bus
> is needed due to sysfs nodes under /sys/bus.
> 
> I opted to keep it on a separate patch, in order to preserve the history, and properly
> document why this is needed.

We don't apply patches causing oopses like that because this breaks
bisection.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
