Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248Ab2LAEnX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 23:43:23 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:51679 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613Ab2LAEnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 23:43:21 -0500
MIME-Version: 1.0
In-Reply-To: <50B8D86E.1080109@gmail.com>
References: <1354058956-7199-1-git-send-email-swarren@wwwdotorg.org>
	<50B8D86E.1080109@gmail.com>
Date: Sat, 1 Dec 2012 07:43:19 +0300
Message-ID: <CAMo8Bf+XRMO=Wfiyas5wvcusZn70d-j3v6ZWvTCp6cB4vs7G-g@mail.gmail.com>
Subject: Re: [PATCH V7 1/7] kbuild: centralize .dts->.dtb rule
From: Max Filippov <jcmvbkbc@gmail.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>, Michal Marek <mmarek@suse.cz>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        Olof Johansson <olof@lixom.net>, Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jonas Bonn <jonas@southpole.se>, linux@openrisc.net,
        Aurelien Jacquiot <a-jacquiot@ti.com>, linux-c6x-dev@linux-c6x.org,
        Mark Salter <msalter@redhat.com>, Michal Simek <monstr@monstr.eu>,
        microblaze-uclinux@itee.uq.edu.au, Chris Zankel <chris@zankel.net>,
        linux-xtensa@linux-xtensa.org, Ralf Baechle <ralf@linux-mips.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2012 at 8:01 PM, Rob Herring <robherring2@gmail.com> wrote:

[...]

>> This is based on next-20121126.
>
> I'll apply the series but I need a stable base. Looks like xtensa has
> the dependency. Or I can just drop xtensa.

Please drop it, I will follow up with a conversion.

-- 
Thanks.
-- Max
