Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758266Ab2J2KsM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 06:48:12 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62490 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817Ab2J2KsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 06:48:11 -0400
MIME-Version: 1.0
In-Reply-To: <1351500524-23907-2-git-send-email-wency@cn.fujitsu.com>
References: <1351500524-23907-1-git-send-email-wency@cn.fujitsu.com>
	<1351500524-23907-2-git-send-email-wency@cn.fujitsu.com>
Date: Mon, 29 Oct 2012 11:48:09 +0100
Message-ID: <CAFLxGvyOo065sc2QeTkFsPotJbJEgEAV_ktvz5Z2gYpD-Ft7WA@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] update mem= option's spec according to its implementation
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Wen Congyang <wency@cn.fujitsu.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Rob Landley <rob@landley.net>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, bhelgaas@google.com,
        "H. Peter Anvin" <hpa@zytor.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 9:48 AM, Wen Congyang <wency@cn.fujitsu.com> wrote:
> Current mem= implementation seems buggy because specification and
> implementation doesn't match. Current mem= has been working
> for many years and it's not buggy, it works as expected. So
> we should update the specification.
>
> Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
> Sort-of-tentatively-acked-by: Rob Landley <rob@landley.net>

So, is this an ACK or not?

-- 
Thanks,
//richard
