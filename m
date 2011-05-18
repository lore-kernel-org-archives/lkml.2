Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792Ab1ERP1O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 11:27:14 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47971 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755255Ab1ERP1M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 11:27:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SrXhu4knv6EXlhvPv5MybBGktAvi3H680bZYmU4hxcX33rr8RvmKAlb0CBzwklq2uB
         84jDZU4cchXIcVqX40K+W15uBvk18lT+wLjbalsXx9MgHihc0XVvzo+qIITF5ym1Z2hT
         KB+Bms4BqREr+86essKD77WO1kHaevVyagnZs=
MIME-Version: 1.0
In-Reply-To: <20110518152237.GA26055@S2100-06.ap.freescale.net>
References: <201105181047.17309.arnd@arndb.de>
	<20110518152237.GA26055@S2100-06.ap.freescale.net>
Date: Wed, 18 May 2011 18:27:11 +0300
Message-ID: <BANLkTimRvwc0UnCu08Ade=xpUMZRtdzVXg@mail.gmail.com>
Subject: Re: [RFC] ARM Subarchitecture group maintainership
From: Anca Emanuel <anca.emanuel@gmail.com>
To: Shawn Guo <shawn.guo@freescale.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Nicolas Pitre <nico@fluxnic.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 6:22 PM, Shawn Guo <shawn.guo@freescale.com> wrote:
> On Wed, May 18, 2011 at 10:47:16AM +0200, Arnd Bergmann wrote:
> [...]
>> +ARM SUBARCHITECTURES
>> +M:   Arnd Bergmann <arnd@arndb.de>
>> +M:   Nicolas Pitre <nico@fluxnic.net>
>> +M:   Thomas Gleixner <tglx@linutronix.de>
>> +M:   arm@kernel.org
>> +L:   linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
>> +S:   MAINTAINED
>> +F:   arch/arm/mach-*/
>> +F:   arch/arm/plat-*/
>> +T:   git git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-subarch.git
>
> Is this repository ready for use yet?  It seems not for me.

Did you read it ?
[quote]We will probably not be fully functional during the 2.6.40 merge window,
but we are trying our best to be useful. For 2.6.41, my hope is that
we can merge the bulk of the ARM subarchitecture changes through this
tree.[/quote]
