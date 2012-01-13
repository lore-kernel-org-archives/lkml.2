Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758489Ab2AMQRw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 11:17:52 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42146 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758463Ab2AMQRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 11:17:48 -0500
Message-ID: <4F1066F8.4000602@mvista.com>
Date: Fri, 13 Jan 2012 20:16:40 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Akinobu Mita <akinobu.mita@gmail.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Robert Richter <robert.richter@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 3/7] bitops: introduce list_for_each_clear_bit
References: <1326470004-10096-1-git-send-email-akinobu.mita@gmail.com> <1326470004-10096-4-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1326470004-10096-4-git-send-email-akinobu.mita@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 01/13/2012 06:53 PM, Akinobu Mita wrote:

> Introduce list_for_each_clear_bit() and list_for_each_clear_bit_from().

    It seems you've got somewhat muddled -- you're actually introducing 
for_each_clear_bit() and for_each_clear_bit_from()

> They are similar to for_each_set_bit() and list_for_each_set_bit_from(),
> but they iterate over all the cleared bits in a memory region.

> Signed-off-by: Akinobu Mita<akinobu.mita@gmail.com>
> Cc: Robert Richter<robert.richter@amd.com>
> Cc: Thomas Gleixner<tglx@linutronix.de>
> Cc: Ingo Molnar<mingo@redhat.com>
> Cc: "H. Peter Anvin"<hpa@zytor.com>
> Cc: x86@kernel.org
> Cc: David Woodhouse<dwmw2@infradead.org>
> Cc: linux-mtd@lists.infradead.org
> Cc: Martin Schwidefsky<schwidefsky@de.ibm.com>
> Cc: Heiko Carstens<heiko.carstens@de.ibm.com>
> Cc: linux390@de.ibm.com
> Cc: linux-s390@vger.kernel.org
> Cc: linux-usb@vger.kernel.org

WBR, Sergei

