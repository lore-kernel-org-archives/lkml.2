Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932701Ab3AJB4K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 20:56:10 -0500
Received: from mail-bk0-f53.google.com ([209.85.214.53]:46154 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932555Ab3AJB4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 20:56:09 -0500
MIME-Version: 1.0
In-Reply-To: <20130107155544.GD29449@x1.alien8.de>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
	<1357260531-11115-9-git-send-email-yinghai@kernel.org>
	<20130107155544.GD29449@x1.alien8.de>
Date: Wed, 9 Jan 2013 17:56:07 -0800
X-Google-Sender-Auth: NhM8-dvsNC5I2NfgbP6kzy1Syxs
Message-ID: <CAE9FiQXcP9E-RXre_NKf-SU454nT9K39f1GsVVroV1TFxPgQ7g@mail.gmail.com>
Subject: Re: [PATCH v7u1 08/31] x86, 64bit: early #PF handler set page table
From: Yinghai Lu <yinghai@kernel.org>
To: Borislav Petkov <bp@alien8.de>, Yinghai Lu <yinghai@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 7, 2013 at 7:55 AM, Borislav Petkov <bp@alien8.de> wrote:
> Those -vXX version lines need to go under the "---" line. Alternatively,
> you might want to add some of them to the commit message with a proper
> explanation since they are not that trivial at a first glance, for
> example the -v5, -v6, -v8, -v9 with a better explanation.

mostly they are for tracking version.

>
>>
>
> This needs hpa's S-O-B.

he will add later when he put the in the tip.
