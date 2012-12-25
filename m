Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902Ab2LYLVD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 06:21:03 -0500
Received: from mail.skyhub.de ([78.46.96.112]:60801 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753825Ab2LYLVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 06:21:00 -0500
Date: Tue, 25 Dec 2012 12:20:57 +0100
From: Borislav Petkov <bp@alien8.de>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Jan Kiszka <jan.kiszka@web.de>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 06/27] x86, 64bit: early #PF handler set page table
Message-ID: <20121225112057.GC7720@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
	Jason Wessel <jason.wessel@windriver.com>,
	Jan Kiszka <jan.kiszka@web.de>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <1355814959-10573-1-git-send-email-yinghai@kernel.org>
 <1355814959-10573-7-git-send-email-yinghai@kernel.org>
 <CAE9FiQXrpQtZ7Sq=xfjscKjKzZ6P89uPG0bByER8q48jEgYx_g@mail.gmail.com>
 <50D0D6D1.70400@zytor.com>
 <CAE9FiQV5zpTiskB_RwXT8XGNfgTGSwc3AAFqCBusq1t4-OSJHw@mail.gmail.com>
 <50D0DB1A.5010407@zytor.com>
 <CAE9FiQV2U+Am0zCz__6YL4CoOeie5McE9=g-L3A_udRNN1rPTw@mail.gmail.com>
 <50D8F054.20404@zytor.com>
 <CAE9FiQW_mjUr6F0q7PhZWCcDzZ+NJpi0-xjxvwJoZ1K+XAUjSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAE9FiQW_mjUr6F0q7PhZWCcDzZ+NJpi0-xjxvwJoZ1K+XAUjSQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 24, 2012 at 08:04:18PM -0800, Yinghai Lu wrote:
> well, I updated for-x86-boot-v7 that stop #PF handler after
> init_mem_mapping.
>
> it has fix for AMD system aka reverting far jmp to ret.

-v7?

You told me yesterday -v8 is the current branch. Do you have -v7 which
does break KGDB and -v8 which breaks it and both branches are current?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
