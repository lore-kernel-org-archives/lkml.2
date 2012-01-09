Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932373Ab2AIQjq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 11:39:46 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:50476 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932266Ab2AIQjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 11:39:45 -0500
MIME-Version: 1.0
In-Reply-To: <1325945558-4661-1-git-send-email-corentincj@iksaif.net>
References: <20120105150832.GA25386@ubuntu-macmini>
	<1325945558-4661-1-git-send-email-corentincj@iksaif.net>
Date: Mon, 9 Jan 2012 17:39:43 +0100
Message-ID: <CANq1E4QGahjrxm5B59HGnrfO3LP4kV6bc27BKQDvnJ4HBKAFMg@mail.gmail.com>
Subject: Re: [PATCH] ACPI / Video: blacklist some samsung laptops
From: David Herrmann <dh.herrmann@googlemail.com>
To: Corentin Chary <corentincj@iksaif.net>
Cc: platform-driver-x86@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        linux-kernel@vger.kernel.org, Andrzej Prochyra <andrzej@prochyra.name>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        =?ISO-8859-1?Q?Richard_Sch=FCtz?= <r.schtz@t-online.de>,
        Seth Forshee <seth.forshee@canonical.com>, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Corentin

On Sat, Jan 7, 2012 at 3:12 PM, Corentin Chary <corentincj@iksaif.net> wrote:
> On these laptops, the ACPI video is not functional, and very unlikely
> to be fixed by the vendor. Note that intel_backlight works for some
> of these laptops, and the backlight from samsung-laptop always work.
>
> The good news is that newer laptops have functional ACPI video device
> and won't end up growing this list.
>
> Signed-off-by: Corentin Chary <corentincj@iksaif.net>
> ---
>
> Could the concerned people test this patch and check that it correctly
> disable the acpi_video backlight ?

Works like a charm on my N210 with linux-3.2. Feel free to add a:
Tested-by: David Herrmann <dh.herrmann@googlemail.com>

I will talk to the intel drm developers about the intel_backlight
issues as they don't seem related to this driver.

Thanks
David
