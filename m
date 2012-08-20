Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995Ab2HTGoe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 02:44:34 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:61371 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386Ab2HTGoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 02:44:30 -0400
MIME-Version: 1.0
In-Reply-To: <20120820161146.8961b8d9151f11a27b2fb48f@canb.auug.org.au>
References: <20120820161146.8961b8d9151f11a27b2fb48f@canb.auug.org.au>
Date: Mon, 20 Aug 2012 14:44:29 +0800
X-Google-Sender-Auth: 5h-DDQ4HgzohSkx52yp61yUBMxQ
Message-ID: <CAMz9Wg9cFU_fya0oCcwSotTrp24nbkafzL7QA=MYLvXmEy8jJQ@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the drivers-x86 tree
From: AceLan Kao <acelan.kao@canonical.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "John W. Linville\"" <linville@tuxdriver.com>,
        Julian Calaby <julian.calaby@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The commit 154a7a7b2234 ("asus-wmi: update wlan LED through rfkill led trigger")
needs another patch which was submitted to rfkill, but still not be merged yet.
see https://patchwork.kernel.org/patch/1240091/

Sorry for leading to the problem.

Best regards,
AceLan Kao.

2012/8/20 Stephen Rothwell <sfr@canb.auug.org.au>:
> Hi Matthew,
>
> After merging the drivers-x86 tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>
> drivers/platform/x86/asus-wmi.c: In function 'asus_new_rfkill':
> drivers/platform/x86/asus-wmi.c:892:3: error: implicit declaration of function 'rfkill_set_led_trigger_name' [-Werror=implicit-function-declaration]
>
> Caused by commit 154a7a7b2234 ("asus-wmi: update wlan LED through rfkill
> led trigger").  Please build test this stuff ... according to the bug
> report, this patch depends on another rfkill patch.
>
> I have used the drivers-x86 tree from next-20120817 for today.
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au



-- 
Chia-Lin Kao(AceLan)
http://blog.acelan.idv.tw/
E-Mail: acelan.kaoATcanonical.com (s/AT/@/)
