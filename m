Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222Ab3AGPUx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 10:20:53 -0500
Received: from mail-vc0-f175.google.com ([209.85.220.175]:52040 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380Ab3AGPUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 10:20:52 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1301061336180.1397@xoschi>
References: <alpine.LNX.2.00.1301061336180.1397@xoschi>
Date: Mon, 7 Jan 2013 10:20:51 -0500
Message-ID: <CADnq5_O1GDuigxwR8eXu7f1Fsb8iqrggVwYBaiOJKOR-ighYag@mail.gmail.com>
Subject: Re: Regression: drm/radeon: brightness control hard system lockup
From: Alex Deucher <alexdeucher@gmail.com>
To: Eldad Zack <eldad@fogrefinery.com>
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <jglisse@redhat.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 6, 2013 at 7:59 AM, Eldad Zack <eldad@fogrefinery.com> wrote:
>
> Hi Alex,
>
> Commit 0ecebb9e0d14e9948e0b1529883a776758117d6f "drm/radeon: switch to a
> finer grained reset for evergreen" introduced a hard system lockup to my
> setup. I found it after bisecting, and confirmed it by reverting it on
> the latest mainline ( 5f243b9 ).
>
> This:
>
>    echo 7 > /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/backlight/acpi_video0/brightness
>
> Causes a hard lock-up hard, i.e. immediate freeze, without any logs.
>
> See lspci output and kernel .config below.
> If there's any more info I can provide, please let me know.


Do you normally see GPU resets when changing the backlight?  Please
attach your dmesg output when changing the backlight with the patch
reverted.

Alex
