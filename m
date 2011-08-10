Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702Ab1HJOYt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 10:24:49 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:45868 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab1HJOYq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 10:24:46 -0400
MIME-Version: 1.0
In-Reply-To: <225E012C-3134-4F86-A130-B205145D3E18@kernel.crashing.org>
References: <1312445581-16283-1-git-send-email-galak@kernel.crashing.org>
	<20110804194520.5a3dbd38@pyx>
	<225E012C-3134-4F86-A130-B205145D3E18@kernel.crashing.org>
Date: Wed, 10 Aug 2011 17:24:45 +0300
Message-ID: <CAMhs6YyjTD5V3=xBJQj9UDeG7WcoPfsH7WQdE0k6CM4UPme2=A@mail.gmail.com>
Subject: Re: [PATCH] 8250: Fix compiler warning
From: Maxin B John <maxin.john@gmail.com>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On Wed, Aug 10, 2011 at 5:01 PM, Kumar Gala <galak@kernel.crashing.org> wrote:
>
> On Aug 4, 2011, at 1:45 PM, Alan Cox wrote:
>
>> On Thu,  4 Aug 2011 03:13:01 -0500
>> Kumar Gala <galak@kernel.crashing.org> wrote:
>>
>>> drivers/tty/serial/8250.c: In function 'serial8250_shutdown':
>>> drivers/tty/serial/8250.c:1775:19: warning: 'i' may be used uninitialized in this function
>>
>> NAK, as with all the previous nacks of this.
>>
>> Use a newer gcc - modern gcc gets it right.

Can we use "uninitialized_var(x)" present in "linux/compiler-gcc.h"
in this scenario ?
ie:
struct irq_info *uninitialized_var(i);

Warm Regards,
Maxin
