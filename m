Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414Ab1AUAmF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 19:42:05 -0500
Received: from smtp-out.google.com ([216.239.44.51]:19043 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754043Ab1AUAmD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 19:42:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LO54W0DZv6MzyrwgrfM0w11tb2h88V/rvadE5N/8En9M0pJXBuiSgw2EfMk+e0qB5+
         T/Mh/5pQj4lvRlFM0m1Q==
MIME-Version: 1.0
In-Reply-To: <1295555565-21563-1-git-send-email-dwalker@codeaurora.org>
References: <1295555565-21563-1-git-send-email-dwalker@codeaurora.org>
Date: Thu, 20 Jan 2011 16:42:00 -0800
Message-ID: <AANLkTik+HCj9dkD2s4WgwCqKWCXDbdSnKDUbyGfYfaPr@mail.gmail.com>
Subject: Re: [PATCH 0/7] Nexus One Support
From: Dima Zavin <dmitriyz@google.com>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, davidb@codeaurora.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You are not the author of any of these patches. Where are the author
attributions for the team that actually wrote this code?

--Dima

On Thu, Jan 20, 2011 at 12:32 PM, Daniel Walker <dwalker@codeaurora.org> wrote:
> This series adds basic Nexus One support which includes a booting
> kernel, and functional MMC .
>
> Most people won't be able to use this yet unfortunately because
> you need a serial cable to get any output. However, it's a start.
>
> Brian Swetland (1):
>  [ARM] msm: qsd8k memory base is at 0x20000000
>
> Daniel Walker (6):
>  msm: qsd8x50: add uart platform data
>  msm: qsd8x50: add acpuclock code
>  msm: mahimahi: add mahimahi board file
>  msm: mahimahi: add in mmc support code
>  msm: mahimahi: add gpio pin muxing code
>  msm: mahimahi: initialize mmc at start up
>
>  arch/arm/mach-msm/Kconfig              |    8 +-
>  arch/arm/mach-msm/Makefile             |    5 +-
>  arch/arm/mach-msm/Makefile.boot        |    5 +
>  arch/arm/mach-msm/acpuclock-qsd8x50.c  |  457 ++++++++++++++++++++++++++++++++
>  arch/arm/mach-msm/board-mahimahi-mmc.c |  238 +++++++++++++++++
>  arch/arm/mach-msm/board-mahimahi.c     |   52 +++-
>  arch/arm/mach-msm/board-mahimahi.h     |  147 ++++++++++
>  arch/arm/mach-msm/devices-qsd8x50.c    |   42 +++
>  arch/arm/mach-msm/include/mach/board.h |    1 +
>  9 files changed, 942 insertions(+), 13 deletions(-)
>  create mode 100644 arch/arm/mach-msm/acpuclock-qsd8x50.c
>  create mode 100644 arch/arm/mach-msm/board-mahimahi-mmc.c
>  create mode 100644 arch/arm/mach-msm/board-mahimahi.h
>
> --
> Sent by a consultant of the Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
