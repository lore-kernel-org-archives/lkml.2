Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932236Ab1BKBou (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 20:44:50 -0500
Received: from smtp-out.google.com ([216.239.44.51]:47778 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094Ab1BKBot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 20:44:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=J/+4jGjWP6I3X4Dj38J38qE+6Si4NDsqAKqcx1tAOSbJJb9C4UbZ/HdeLG/7rbw4Tx
         yYiGvcL9O8qEHQQKI1vg==
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF0310F60414@HQMAIL01.nvidia.com>
References: <1297320204-31882-1-git-send-email-ccross@android.com>
	<1297320204-31882-11-git-send-email-ccross@android.com>
	<74CDBE0F657A3D45AFBB94109FB122FF0310F60414@HQMAIL01.nvidia.com>
Date: Thu, 10 Feb 2011 17:44:31 -0800
X-Google-Sender-Auth: L4bhSjgy3DI_rxCr6JrpliE5Qmc
Message-ID: <AANLkTi=ZrTsvLoocLeztqzGK4TUgt1pFnHR-0MBUmOc0@mail.gmail.com>
Subject: Re: [PATCH v4 10/15] ARM: tegra: iomap: Add missing devices, fix use
 of SZ_8, SZ_64
From: Colin Cross <ccross@android.com>
To: Stephen Warren <swarren@nvidia.com>
Cc: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "olof@lixom.net" <olof@lixom.net>,
        "konkers@android.com" <konkers@android.com>,
        Gary King <gking@nvidia.com>, Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 10, 2011 at 8:45 AM, Stephen Warren <swarren@nvidia.com> wrote:
> Colin Cross wrote at Wednesday, February 09, 2011 11:43 PM:
>>
>> From: Gary King <gking@nvidia.com>
>>
>> Adds gart, hdmi, avp, host1x, and pwm controllers to mach/iomap.h
>> There is no SZ_8 or SZ_64, replace them with constants
>
> Can't we add those SZ_* constants?

Sure, you already added SZ_64, and nothing depends on the SZ_8 defines
right now, so I'll drop that part of the change and send a patch that
completes the SZ_* defines.
