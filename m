Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950Ab2KPRJ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 12:09:27 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:55747 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333Ab2KPRJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 12:09:23 -0500
Message-ID: <50A6733F.7020101@wwwdotorg.org>
Date: Fri, 16 Nov 2012 10:09:19 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Alexandre Courbot <acourbot@nvidia.com>
CC: Anton Vorontsov <cbouatmailru@gmail.com>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Mark Zhang <markz@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
        Alexandre Courbot <gnurou@gmail.com>, linux-fbdev@vger.kernel.org,
        linux-pm@vger.kernel.org,
        Leela Krishna Amudala <l.krishna@samsung.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH v8 3/3] Take maintainership of power sequences
References: <1353047903-14363-1-git-send-email-acourbot@nvidia.com> <1353047903-14363-4-git-send-email-acourbot@nvidia.com>
In-Reply-To: <1353047903-14363-4-git-send-email-acourbot@nvidia.com>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2012 11:38 PM, Alexandre Courbot wrote:
> Add entry for power sequences into MAINTAINERS with all the needed
> contact and SCM info.

Acked-by: Stephen Warren <swarren@nvidia.com>

> diff --git a/MAINTAINERS b/MAINTAINERS

> +POWER SEQUENCES
> +M:	Alexandre Courbot <acourbot@nvidia.com>
> +S:	Maintained

Given you're presumably working on this on NVIDIA's time, perhaps make
that "Supported" not "Maintained"?
