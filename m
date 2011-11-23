Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757519Ab1KWGWN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 01:22:13 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52410 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438Ab1KWGWL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 01:22:11 -0500
MIME-Version: 1.0
In-Reply-To: <20111122221829.GB24283@suse.de>
References: <1321999366-23784-1-git-send-email-corentincj@iksaif.net>
	<1321999366-23784-6-git-send-email-corentincj@iksaif.net>
	<20111122221829.GB24283@suse.de>
Date: Wed, 23 Nov 2011 07:22:08 +0100
Message-ID: <CAHR064iYA+370fnoqzAMzcXMKga+x0XmkcR2Zoc+hvqHe_5CgA@mail.gmail.com>
Subject: Re: [PATCH 05/15] samsung-laptop: ehance SABI support
From: Corentin Chary <corentin.chary@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: platform-driver-x86@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 11:18 PM, Greg KH <gregkh@suse.de> wrote:
> On Tue, Nov 22, 2011 at 11:02:36PM +0100, Corentin Chary wrote:
>> * SABI command are on 16 bits, not 8
>
> Are you sure about that?  I guess this would work, and we rely on the
> bits being in the right order so everything works properly?

Yep, I'm pretty sure this is the case, but I've not yet found a
command using more than 8 bits. Anyway the 16 bit code works
flawlessly here since we were already using "writew(command, ...);"
since the beginning.

Regarding the bits order, the driver depends on X86, so I don't see
this as a real issue.

>> * SABI can read/write up to 11 byte of data
>
> It can?

That's how it seems to work, but I didn't see any command using more
that 24 bits yet.

>> * There is not real difference between "get" and "set"
>>   commands, so refactorise the code of both functions
>
> Ah, nice, I always wanted to do that.
>
>> Signed-off-by: Corentin Chary <corentincj@iksaif.net>
>
> Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
>
>



-- 
Corentin Chary
http://xf.iksaif.net
