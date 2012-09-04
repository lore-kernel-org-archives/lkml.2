Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932800Ab2IDVqW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 17:46:22 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38563 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757779Ab2IDVqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 17:46:19 -0400
MIME-Version: 1.0
In-Reply-To: <1346794495.4732.221.camel@misato.fc.hp.com>
References: <1346707623-31476-1-git-send-email-yinghai@kernel.org>
	<1346776024.4732.196.camel@misato.fc.hp.com>
	<CAE9FiQXN1kDwSPTH5UWvDPbrtqGgcEKR4dWwYrP57H4aSA-UMA@mail.gmail.com>
	<1346794495.4732.221.camel@misato.fc.hp.com>
Date: Tue, 4 Sep 2012 14:46:19 -0700
X-Google-Sender-Auth: qnoMBy7OUAgo3MijP1GJFjsbi64
Message-ID: <CAE9FiQVT-0zmE9jyyoWmzM5dd-XAXmHgT+vGqSUKgE2yuPOOvg@mail.gmail.com>
Subject: Re: [PATCH] ACPI: Enable SCI_EMULATE to manually simulate physical
 hotplug testing.
From: Yinghai Lu <yinghai@kernel.org>
To: Toshi Kani <toshi.kani@hp.com>
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ashok Raj <ashok.raj@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 4, 2012 at 2:34 PM, Toshi Kani <toshi.kani@hp.com> wrote:
> On Tue, 2012-09-04 at 12:17 -0700, Yinghai Lu wrote:
>  - If a full path is specified in acpi_name, it ignores the arg hsb
> ("\_SB").
>  - If a relative path is specified in acpi_name, it appends the arg hsb.
>
> So, the code looks good to me; assuming that is the intent.
>
> However, the error message below will show up like "\_SB.\_SB.PCIB" when
> a full path is specified.

I always use
echo "\_SB.PCIB 3" > /sys/kernel/debug/acpi/sci_notify

and it works.

so assume that function can accept \_SB.PCIB and PCIB both.

Thanks

Yinghai
