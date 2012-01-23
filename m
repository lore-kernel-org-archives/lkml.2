Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138Ab2AWK2N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 05:28:13 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:64733 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753095Ab2AWK2M convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 05:28:12 -0500
MIME-Version: 1.0
In-Reply-To: <4F1478B0.6080200@zytor.com>
References: <201111160019.51303.rjw@sisk.pl>
	<201201091700.09318.roucaries.bastien@gmail.com>
	<20120116004110.GA21240@srcf.ucam.org>
	<CAE2SPAZH9vQ=7mTxaCGY6DHdf5Yvv-0SWCwUobUY3tTD5caLow@mail.gmail.com>
	<4F1478B0.6080200@zytor.com>
Date: Mon, 23 Jan 2012 11:28:11 +0100
Message-ID: <CAE2SPAak9xnN8Tbjru3eLN79_JGTGaPWi7w+t=7peN-Nd9f+Bw@mail.gmail.com>
Subject: Re: [PATCH] x86 / reboot: Blacklist Dell OptiPlex 990 known to
 require PCI reboot
From: Bastien ROUCARIES <roucaries.bastien@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 8:21 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 01/16/2012 03:27 AM, Bastien ROUCARIES wrote:
>>>
>>> Does it work if you disable VT-d in the firmware? If so, then adding it
>>> to the reboot method blacklist is the wrong fix - we need to figure out
>>> why VT-d interferes with Dell's reboot code.
>>
>> Yes it work
>>
>
> This is particularly so since we are very close to having a full Dell
> model catalogue in the kernel...

Ping ? Do you need some dump ? testing ?

Bastien

>        -hpa
>
