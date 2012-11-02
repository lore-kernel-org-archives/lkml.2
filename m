Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758222Ab2KBQHc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 12:07:32 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:55206 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179Ab2KBQH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 12:07:28 -0400
MIME-Version: 1.0
In-Reply-To: <5093EC1B.2050800@suse.cz>
References: <1350592007-9216-1-git-send-email-jslaby@suse.cz>
 <1350592007-9216-22-git-send-email-jslaby@suse.cz> <50897E98.5080502@gmail.com>
 <50911F67.3040303@suse.cz> <CA+1xoqfZ5DHVi44Y_a5EmXYeN6Eh=COSP4CiA6tM-aqJE1vBoQ@mail.gmail.com>
 <5091448D.3@suse.cz> <CA+1xoqdRBCQYBQdK-=KJohtua_wD_fp4akk6_jS0x3x82fRp5g@mail.gmail.com>
 <5093EC1B.2050800@suse.cz>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Fri, 2 Nov 2012 12:07:07 -0400
Message-ID: <CA+1xoqdRV5LORTDM9iiTRQwCdGK9XqcW54zyh03M-c-mVU2YLQ@mail.gmail.com>
Subject: Re: [PATCH 21/21] TTY: move tty buffers to tty_port
To: Jiri Slaby <jslaby@suse.cz>
Cc: Jiri Slaby <jirislaby@gmail.com>, gregkh@linuxfoundation.org,
        alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 2, 2012 at 11:51 AM, Jiri Slaby <jslaby@suse.cz> wrote:
> On 10/31/2012 04:59 PM, Sasha Levin wrote:
>> So you probably want a lot more than 100k syscalls, why limit it at
>> all actually?
>
> I unset the limit but I still can't reproduce...
>
>> I've attached my .config for the guest kernel as reference.
>
> Even using this config does not help to reproduce that.
>
> Do you use some special trinity params?

Not really:

    ./trinity -m --quiet --dangerous -l off

Can I add something to my kernel to provide more info when it happens?


Thanks,
Sasha
