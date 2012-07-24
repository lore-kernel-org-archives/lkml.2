Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301Ab2GXNRb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 09:17:31 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:40658 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754144Ab2GXNR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 09:17:28 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AloMAAGgDlBbdWOb/2dsb2JhbABFhSxEqzIiiCaBB4IgAQEEASMPAQUdIwEFCwsaAgUWCwICCQMCAQIBRQYNAQUCAQGIAwqoJpMigSCQDIESA5VJkA2CYQ
X-IronPort-AV: E=Sophos;i="4.77,646,1336341600"; 
   d="scan'208";a="548313881"
Message-ID: <500EA066.8000601@igalia.com>
Date: Tue, 24 Jul 2012 15:17:26 +0200
From: =?UTF-8?B?TWlndWVsIEfDs21leg==?= <magomez@igalia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: =?UTF-8?B?TWlndWVsIEfDs21leg==?= <magomez@igalia.com>
CC: cascardo@holoscopio.com, don@syst.com.br, mjg@redhat.com,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] classmate-laptop: Fix extra keys hardware id.
References: <20120724030946.GA2742@nautilus.holoscopio.com> <1343135125-18733-1-git-send-email-magomez@igalia.com>
In-Reply-To: <1343135125-18733-1-git-send-email-magomez@igalia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Since ACPI devices ids were changed to use always upper-case letters, the ACPI
> id of the extra keys (FNBT0000) was not maching the one defined in the driver
> (FnBT0000), causing the extra keys not to work.
>
> The patch replaces the driver id with the one reported by ACPI, fixing the
> problem.
>
> Signed-off-by: Miguel Gómez <magomez@igalia.com>

I've created this patch on top of linux-next, but it won't apply over 
the patch I've just sent for the accelerometer (neither the later over 
the former).

How do you want me to proceed? Should I sent this again over the 
accelerometer patch?

Regards!

-- 
Miguel Gómez
Igalia - http://www.igalia.com
