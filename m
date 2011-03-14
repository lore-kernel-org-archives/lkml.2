Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000Ab1CNQuE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 12:50:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53751 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006Ab1CNQuC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 12:50:02 -0400
Message-ID: <4D7E470E.8090204@zytor.com>
Date: Mon, 14 Mar 2011 09:49:18 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        greg@kroah.com, joe@perches.com, akpm@linux-foundation.org
Subject: Re: [PATCH][rfc] Use int as return type of main in arch/x86/boot/main.c
References: <alpine.LNX.2.00.1103132257430.9985@swampdragon.chaosbits.net> <20110314113254.GA2761@gmail.com>
In-Reply-To: <20110314113254.GA2761@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2011 04:32 AM, Harry Wei wrote:
> On Sun, Mar 13, 2011 at 11:00:09PM +0100, Jesper Juhl wrote:
>> I believe the return type of main should always be 'int'.
>>
>> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> Acked-by: Harry Wei <harryxiyou@gmail.com>

It would make more sense to rename the function to something other than
main().

	-hpa

