Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641Ab2KQGmI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 01:42:08 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:46901 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab2KQGmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 01:42:05 -0500
MIME-Version: 1.0
In-Reply-To: <50A6733F.7020101@wwwdotorg.org>
References: <1353047903-14363-1-git-send-email-acourbot@nvidia.com>
 <1353047903-14363-4-git-send-email-acourbot@nvidia.com> <50A6733F.7020101@wwwdotorg.org>
From: Alexandre Courbot <acourbot@nvidia.com>
Date: Sat, 17 Nov 2012 15:41:43 +0900
X-Google-Sender-Auth: tkwNteHReIIj0sefg8q-nySthwM
Message-ID: <CAAVeFu+YOV-hcx4wAvgVVe0tOGL20pdDe86Qbn7TaC8NB9DG4Q@mail.gmail.com>
Subject: Re: [PATCH v8 3/3] Take maintainership of power sequences
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Mark Zhang <markz@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Leela Krishna Amudala <l.krishna@samsung.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 17, 2012 at 2:09 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> Acked-by: Stephen Warren <swarren@nvidia.com>

Thanks!

>> +POWER SEQUENCES
>> +M:   Alexandre Courbot <acourbot@nvidia.com>
>> +S:   Maintained
>
> Given you're presumably working on this on NVIDIA's time, perhaps make
> that "Supported" not "Maintained"?

Absolutely.

Alex.
