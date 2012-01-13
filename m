Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759510Ab2AMXgG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 18:36:06 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:53006 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759484Ab2AMXgD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 18:36:03 -0500
MIME-Version: 1.0
In-Reply-To: <4F1066F8.4000602@mvista.com>
References: <1326470004-10096-1-git-send-email-akinobu.mita@gmail.com>
	<1326470004-10096-4-git-send-email-akinobu.mita@gmail.com>
	<4F1066F8.4000602@mvista.com>
Date: Sat, 14 Jan 2012 08:36:02 +0900
Message-ID: <CAC5umyiZd34q04r0M3MG3gw8_tFxQ8vxdB27ywiSDG+WjD8=Kg@mail.gmail.com>
Subject: Re: [PATCH 3/7] bitops: introduce list_for_each_clear_bit
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Robert Richter <robert.richter@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/1/14 Sergei Shtylyov <sshtylyov@mvista.com>:
> Hello.
>
> On 01/13/2012 06:53 PM, Akinobu Mita wrote:
>
>> Introduce list_for_each_clear_bit() and list_for_each_clear_bit_from().
>
>
>   It seems you've got somewhat muddled -- you're actually introducing
> for_each_clear_bit() and for_each_clear_bit_from()

Oops, thanks for a notification.
