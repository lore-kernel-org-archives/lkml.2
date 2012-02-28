Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965051Ab2B1BbF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 20:31:05 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:57870 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756477Ab2B1BbC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 20:31:02 -0500
MIME-Version: 1.0
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F03F633@ORSMSX104.amr.corp.intel.com>
References: <1330384105-27794-1-git-send-email-paul.gortmaker@windriver.com>
	<3908561D78D1C84285E8C5FCA982C28F03F633@ORSMSX104.amr.corp.intel.com>
Date: Mon, 27 Feb 2012 20:31:01 -0500
X-Google-Sender-Auth: TW5bkAKGwhZSOf2JbXu4oMb828k
Message-ID: <CAP=VYLoPTWnGANBo0hmGFxu7U7pZWePdX5Atb3A=dBNeSfbfJA@mail.gmail.com>
Subject: Re: [PATCH] ia64: fix a couple of warnings for EXPORT_SYMBOL
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "jes@trained-monkey.org" <jes@trained-monkey.org>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 27, 2012 at 7:18 PM, Luck, Tony <tony.luck@intel.com> wrote:
> [I can carry this patch if required, but it is 100% independent and
>  can go in via the ia64 maintainers.  Let me know which is best. ]
>
> I'll take it into the ia64 tree (already grabbed the machine_kexec.c
> and tiocx.c patches you posted earlier).

Hi Tony,

Great -- thanks for the reply, I will adjust my queues accordingly.

Paul.
---

>
> -Tony
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
