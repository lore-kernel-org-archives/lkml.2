Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558Ab2HCMB4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 08:01:56 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64515 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746Ab2HCMBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 08:01:54 -0400
MIME-Version: 1.0
In-Reply-To: <1341562023-6951-1-git-send-email-ike.pan@canonical.com>
References: <4FF45C98.60305@gmail.com> <1341562023-6951-1-git-send-email-ike.pan@canonical.com>
From: =?KOI8-U?B?7cHL08nNIO3Jy8nU0c7Ty8nK?= <maxtram95@gmail.com>
Date: Fri, 3 Aug 2012 15:01:32 +0300
Message-ID: <CAKErNvrrOBDU84m1Og=MX19mVMGG_P+s7X1ZUYebsEbqE7W+Mw@mail.gmail.com>
Subject: Re: [PATCH 0/4] ideapad: patches for v3.6 merge window
To: Ike Panhc <ike.pan@canonical.com>
Cc: Matthew Garrett <mjg@redhat.com>, Dan Carpenter <dan.carpenter@oracle.com>,
        Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, platform-driver-x86@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will these patches appear in 3.6? RC1 is already available, but it
doesn't contain these patches.

2012/7/6 Ike Panhc <ike.pan@canonical.com>:
>
> One minor fix on part 2 for z570 is to let CONFIG_IDEAPAD depends on
> CONFIG_SERIO_I8042
>
>
> The following changes since commit 71351f14b3b941eb7178567b1272d934609cb785:
>
>   Linux 3.5-rc5 (2012-07-05 14:09:43 +0800)
>
> are available in the git repository at:
>
>   git://kernel.ubuntu.com/ikepanhc/public.git ideapad-3.6
>
> for you to fetch changes up to 583f18e1378d1b15fa35333be02b79e4f9315f59:
>
>   ideapad: add Lenovo IdeaPad Z570 support (part 3) (2012-07-06 15:12:49 +0800)
>
>
> Dan Carpenter (1):
>   ideapad: uninitialized data in ideapad_acpi_add()
>
> Maxim Mikityanskiy (3):
>   ideapad: add Lenovo IdeaPad Z570 support (part 1)
>   ideapad: add Lenovo IdeaPad Z570 support (part 2)
>   ideapad: add Lenovo IdeaPad Z570 support (part 3)
>
>  .../ABI/testing/sysfs-platform-ideapad-laptop      |   11 ++
>  drivers/platform/x86/Kconfig                       |    1 +
>  drivers/platform/x86/ideapad-laptop.c              |  115 ++++++++++++++++++--
>  3 files changed, 120 insertions(+), 7 deletions(-)
>
> --
> 1.7.9.5
>
