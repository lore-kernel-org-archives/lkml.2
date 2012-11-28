Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755831Ab2K1Rof (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 12:44:35 -0500
Received: from service87.mimecast.com ([91.220.42.44]:35821 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755811Ab2K1Rod convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 12:44:33 -0500
Date: Wed, 28 Nov 2012 17:44:26 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Michal Marek <mmarek@suse.cz>, Grant Likely <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Olof Johansson <olof@lixom.net>, Russell King <linux@arm.linux.org.uk>,
        Jonas Bonn <jonas@southpole.se>,
        "linux@openrisc.net" <linux@openrisc.net>,
        Aurelien Jacquiot <a-jacquiot@ti.com>,
        "linux-c6x-dev@linux-c6x.org" <linux-c6x-dev@linux-c6x.org>,
        "msalter@redhat.com" <msalter@redhat.com>,
        Michal Simek <monstr@monstr.eu>,
        "microblaze-uclinux@itee.uq.edu.au" 
	<microblaze-uclinux@itee.uq.edu.au>,
        Chris Zankel <chris@zankel.net>,
        "linux-xtensa@linux-xtensa.org" <linux-xtensa@linux-xtensa.org>,
        Max Filippov <jcmvbkbc@gmail.com>, Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH V7 1/7] kbuild: centralize .dts->.dtb rule
Message-ID: <20121128174426.GD17405@arm.com>
References: <1354058956-7199-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
In-Reply-To: <1354058956-7199-1-git-send-email-swarren@wwwdotorg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-MC-Unique: 112112817443100701
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 11:29:10PM +0000, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
> 
> All architectures that use cmd_dtc do so in almost the same way. Create
> a central build rule to avoid duplication. The one difference is that
> most current uses of dtc build $(obj)/%.dtb from $(src)/dts/%.dts rather
> than building the .dtb in the same directory as the .dts file. This
> difference will be eliminated arch-by-arch in future patches.
> 
> MIPS is the exception here; it already uses the exact same rule as the
> new common rule, so the duplicate is removed in this patch to avoid any
> conflict. arch/mips changes courtesy of Ralf Baechle.
> 
> Update Documentation/kbuild to remove the explicit call to cmd_dtc from
> the example, now that the rule exists in a centralized location.
> 
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: Olof Johansson <olof@lixom.net>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Jonas Bonn <jonas@southpole.se>
> Cc: linux@lists.openrisc.net
> Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
> Cc: linux-c6x-dev@linux-c6x.org
> Cc: Mark Salter <msalter@redhat.com>
> Cc: Michal Simek <monstr@monstr.eu>
> Cc: microblaze-uclinux@itee.uq.edu.au
> Cc: Chris Zankel <chris@zankel.net>
> Cc: linux-xtensa@linux-xtensa.org
> Cc: Max Filippov <jcmvbkbc@gmail.com>
> Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>

