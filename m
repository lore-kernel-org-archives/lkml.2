Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157Ab2APTVp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 14:21:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49992 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755069Ab2APTVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 14:21:44 -0500
Message-ID: <4F1478B0.6080200@zytor.com>
Date: Mon, 16 Jan 2012 11:21:20 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Bastien ROUCARIES <roucaries.bastien@gmail.com>
CC: Matthew Garrett <mjg59@srcf.ucam.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org
Subject: Re: [PATCH] x86 / reboot: Blacklist Dell OptiPlex 990 known to require
 PCI reboot
References: <201111160019.51303.rjw@sisk.pl> <201201091700.09318.roucaries.bastien@gmail.com> <20120116004110.GA21240@srcf.ucam.org> <CAE2SPAZH9vQ=7mTxaCGY6DHdf5Yvv-0SWCwUobUY3tTD5caLow@mail.gmail.com>
In-Reply-To: <CAE2SPAZH9vQ=7mTxaCGY6DHdf5Yvv-0SWCwUobUY3tTD5caLow@mail.gmail.com>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2012 03:27 AM, Bastien ROUCARIES wrote:
>>
>> Does it work if you disable VT-d in the firmware? If so, then adding it
>> to the reboot method blacklist is the wrong fix - we need to figure out
>> why VT-d interferes with Dell's reboot code.
> 
> Yes it work
> 

This is particularly so since we are very close to having a full Dell
model catalogue in the kernel...

	-hpa

