Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281Ab1FOUWE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 16:22:04 -0400
Received: from smtp-out.google.com ([74.125.121.67]:21462 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754546Ab1FOUWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 16:22:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=qQUVwFU2sJ7mdxO5y4lONFJZwLLOo4MpmtOLzV6AJA9BSkLoToB0rewy1VsozkcWBD
         Rpqie9i2R6V1PrVwy6kA==
MIME-Version: 1.0
In-Reply-To: <20110615193734.23641.8004.stgit@ponder>
References: <20110615193734.23641.8004.stgit@ponder>
Date: Wed, 15 Jun 2011 13:21:56 -0700
X-Google-Sender-Auth: e7S583gVn087oZOPc-QhzMcprvM
Message-ID: <BANLkTinij15PZw11Y3Qt=PV1kkP1pw1oaszTdMfD55Cf8cOJkw@mail.gmail.com>
Subject: Re: [PATCH 1/2] gpio/tegra: Move Tegra gpio driver to drivers/gpio
From: Colin Cross <ccross@android.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Erik Gilling <konkers@android.com>, lkml <linux-kernel@vger.kernel.org>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>,
        spi-devel-general@lists.sourceforge.net,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Warren <swarren@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 12:37 PM, Grant Likely
<grant.likely@secretlab.ca> wrote:
> As part of the gpio driver consolidation, this patch moves the Tegra driver
> into drivers/gpio
>
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> ---
>
> If there are no objections, I'll merge this via gpio/next

I have this patch as part of a series that should get posted later
this week, as well as a patch on top of it that depends on this change
and another change in my tree, but I'm pessimistic that my series will
get in to 3.1 since it depends on some common consolidation that
hasn't been agreed upon yet.  So,
Acked-by: Colin Cross <ccross@android.com>

Put it in gpio/next, and I'll make sure any other Tegra patches with
dependencies get pulled after yours.
