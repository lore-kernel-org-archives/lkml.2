Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751642Ab2CGVCx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 16:02:53 -0500
Received: from www.linutronix.de ([62.245.132.108]:38791 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894Ab2CGVCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 16:02:52 -0500
Message-ID: <4F57CCF4.6040902@linutronix.de>
Date: Wed, 07 Mar 2012 22:02:44 +0100
From: Richard Weinberger <rw@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120215 Thunderbird/10.0.2
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: tglx@linutronix.de, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, tim.bird@am.sony.com
Subject: Re: [RFC][PATCH 1/7] MTD: UBI: Add checkpoint on-chip layout
References: <1329250006-22944-1-git-send-email-rw@linutronix.de> <1329250006-22944-2-git-send-email-rw@linutronix.de> <1331136589.3463.3.camel@sauron.fi.intel.com>
In-Reply-To: <1331136589.3463.3.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 07.03.2012 17:09, schrieb Artem Bityutskiy:
> On Tue, 2012-02-14 at 21:06 +0100, Richard Weinberger wrote:
>> Specify the on-chip checkpoint layout.
>> The checkpoint consists of two major parts.
>> A super block (identified via UBI_CP_SB_VOLUME_ID) and
>> zero or more data blocks (identified via UBI_CP_DATA_VOLUME_ID).
>> Data blocks are only used if whole checkpoint information does not fit
>> into the super block.
>
> And superblock is also a more or less standard name used by file-system.
> I easily imagine difficulties and confusion when discussing UBIFS and
> UBI and mixing UBI and UBIFS supersblocks up. IMHO, anything unique is
> much better, even if it does not make much sense. E.g., "boss block" or
> "pomo block" (pomo = boss in Finnish).
>
> Would you consider picking a different name as well please?
>

Will do.

Thanks,
//richard

