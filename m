Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115Ab0C0Wa4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 18:30:56 -0400
Received: from mail-iw0-f196.google.com ([209.85.223.196]:57700 "EHLO
	mail-iw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754020Ab0C0Waz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 18:30:55 -0400
MIME-Version: 1.0
In-Reply-To: <20100327230727.10def37d.kristoffer.ericson@gmail.com>
References: <1269640391-23451-1-git-send-email-mroberto@cpti.cetuc.puc-rio.br> 
	<20100327230727.10def37d.kristoffer.ericson@gmail.com>
From: Marcelo Jimenez <mroberto@cpti.cetuc.puc-rio.br>
Date: Sat, 27 Mar 2010 19:30:34 -0300
Message-ID: <cecb6d8f1003271530w11943d52hc1c815b23722fb35@mail.gmail.com>
Subject: Re: [PATCH 1/2] ARM: mach-sa1100: Fix for the use of wrong CPU_FREQ 
	code in nanoengine.
To: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Cc: Dmitry Artamonow <mad_soft@inbox.ru>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kristoffer,

On Sat, Mar 27, 2010 at 19:07, Kristoffer Ericson
<kristoffer.ericson@gmail.com> wrote:
> On Fri, 26 Mar 2010 18:53:10 -0300
> Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br> wrote:
>
>> This patch selects the right CPU_FREQ module to use with nanoengine.
>>
>> Signed-off-by: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
>
> I think you should add more information regarding the patch.
> Like addition of memory, extending the sdram_params->name length,
> Cleaning up header content and order.
> Just looking at the commit message it doesnt cover everything thats done.

Ok, will do that.

> Also, for me this doesnt apply at all. It might be my setup
> being corrupt, but is it synced with latest git?
>
> Patch number 2 doesnt either apply for me.

Sorry, they depend upon my first patch set, the one that adds
nanoengine back to the kernel. I thought about merging it with the
first, but I also thought it might cause confusion if someone had
already applied it:

http://lists.arm.linux.org.uk/lurker/message/20100311.200959.9dd2e2d1.en.html

The other patches are:

http://lists.arm.linux.org.uk/lurker/message/20100311.201022.58a74029.en.html
http://lists.arm.linux.org.uk/lurker/message/20100311.201023.17169815.en.html
http://lists.arm.linux.org.uk/lurker/message/20100311.201024.d78c81ac.en.html
http://lists.arm.linux.org.uk/lurker/message/20100311.201025.b9812efa.en.html

http://lists.arm.linux.org.uk/lurker/message/20100312.142346.0f32234c.en.html
http://lists.arm.linux.org.uk/lurker/message/20100312.142347.0c7e0e21.en.html

http://lists.arm.linux.org.uk/lurker/message/20100324.230457.f07b83bd.en.html
http://lists.arm.linux.org.uk/lurker/message/20100324.234510.4e6f1816.en.html

http://lists.arm.linux.org.uk/lurker/message/20100326.215310.ba4ef076.en.html
http://lists.arm.linux.org.uk/lurker/message/20100326.215311.ce1245a0.en.html

A total of eleven patches. The only dependency up to now is that the
last patch depends on the first.

> Best wishes
> Kristoffer

Regards,
Marcelo.
