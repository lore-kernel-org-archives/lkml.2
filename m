Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300Ab2LaCLy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2012 21:11:54 -0500
Received: from mail-qc0-f180.google.com ([209.85.216.180]:36356 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab2LaCLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2012 21:11:51 -0500
MIME-Version: 1.0
In-Reply-To: <20121230061843.GB21331@quad.lixom.net>
References: <1354264973-11214-1-git-send-email-a.kesavan@samsung.com>
	<CAJ0PZbTTDdAXJ378R7CDO2=spx7WF_RpztG5ch7iFZWx-v3N2Q@mail.gmail.com>
	<20121230061843.GB21331@quad.lixom.net>
Date: Mon, 31 Dec 2012 07:41:50 +0530
Message-ID: <CAM4voamC90dHKu3kOr0dMLO=0jsuMrQHs=gwSesdydOmgyhAnw@mail.gmail.com>
Subject: Re: [PATCH RFC] PM/Devfreq: Add Exynos5-bus devfreq driver for Exynos5250.
From: Abhilash Kesavan <kesavan.abhilash@gmail.com>
To: Olof Johansson <olof@lixom.net>
Cc: myungjoo.ham@gmail.com, kyungmin.park@samsung.com, rjw@sisk.pl,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        kgene.kim@samsung.com, jhbird.choi@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

[...]
> Why can't they be in drivers/busfreq? Create a subdirectory for
> platform-specific subdrivers if needed, but they definitiely do NOT
> belong in drivers/misc, and there seems to be little reason to have them
> in arch/arm.
Myungjoo, can you please indicate your preference with respect to where
I should place the PPMU driver. I'll re-work based on that.

Abhilash
