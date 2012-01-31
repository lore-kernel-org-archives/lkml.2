Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276Ab2AaJtw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 04:49:52 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:43280 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751932Ab2AaJtu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 04:49:50 -0500
MIME-Version: 1.0
In-Reply-To: <CAE2SPAak9xnN8Tbjru3eLN79_JGTGaPWi7w+t=7peN-Nd9f+Bw@mail.gmail.com>
References: <201111160019.51303.rjw@sisk.pl>
	<201201091700.09318.roucaries.bastien@gmail.com>
	<20120116004110.GA21240@srcf.ucam.org>
	<CAE2SPAZH9vQ=7mTxaCGY6DHdf5Yvv-0SWCwUobUY3tTD5caLow@mail.gmail.com>
	<4F1478B0.6080200@zytor.com>
	<CAE2SPAak9xnN8Tbjru3eLN79_JGTGaPWi7w+t=7peN-Nd9f+Bw@mail.gmail.com>
Date: Tue, 31 Jan 2012 10:49:48 +0100
Message-ID: <CAE2SPAbHxjQm3-z+LRXYBJAVnrwjMn=u=9RFLmZ6hkc8XtNy+w@mail.gmail.com>
Subject: Re: [PATCH] x86 / reboot: Blacklist Dell OptiPlex 990 known to
 require PCI reboot
From: Bastien ROUCARIES <roucaries.bastien@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping^2

Bastien
On Mon, Jan 23, 2012 at 11:28 AM, Bastien ROUCARIES
<roucaries.bastien@gmail.com> wrote:
> On Mon, Jan 16, 2012 at 8:21 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 01/16/2012 03:27 AM, Bastien ROUCARIES wrote:
>>>>
>>>> Does it work if you disable VT-d in the firmware? If so, then adding it
>>>> to the reboot method blacklist is the wrong fix - we need to figure out
>>>> why VT-d interferes with Dell's reboot code.
>>>
>>> Yes it work
>>>
>>
>> This is particularly so since we are very close to having a full Dell
>> model catalogue in the kernel...
>
> Ping ? Do you need some dump ? testing ?
>
> Bastien
>
>>        -hpa
>>
