Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751674Ab2LSV7I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 16:59:08 -0500
Received: from mail-bk0-f45.google.com ([209.85.214.45]:58330 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736Ab2LSV67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 16:58:59 -0500
MIME-Version: 1.0
In-Reply-To: <20121219205732.GI24895@liondog.tnic>
References: <1355436141-8668-1-git-send-email-yinghai@kernel.org>
	<1355436141-8668-4-git-send-email-yinghai@kernel.org>
	<20121215170625.GA9875@liondog.tnic>
	<CAE9FiQUSoSvtFMMQt3eZkrXFCkzXhLu6GfqYMGNb3=uA052Axw@mail.gmail.com>
	<20121219205732.GI24895@liondog.tnic>
Date: Wed, 19 Dec 2012 13:58:57 -0800
X-Google-Sender-Auth: ffCNlm94JhYFEgq2aJqUghckaCE
Message-ID: <CAE9FiQXOV-GZk6HR17KcDsiPM89=eNHdYRSP2A6n5R_AKnhaLQ@mail.gmail.com>
Subject: Re: [PATCH v6 03/27] x86, boot: move verify_cpu.S and no_longmode
 after 0x200
From: Yinghai Lu <yinghai@kernel.org>
To: Borislav Petkov <bp@alien8.de>, Yinghai Lu <yinghai@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2012 at 12:57 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Tue, Dec 18, 2012 at 07:44:55PM -0800, Yinghai Lu wrote:
>
> So this explains what you're doing but I'd like to know why?
>
> Why do you need to free some more room between startup_32 and
> startup_64? Do you need this room in another patch, maybe the next one:
>
> "[PATCH v7 14/27] x86, boot: Move lldt/ltr out of 64bit code section"
>
> Is that so? If yes, please write that in the commit message so that we
> know why you're doing that change.

duplicate next patch commit log here. no, that's too long.
