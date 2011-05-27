Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758612Ab1E0ABl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 20:01:41 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:41187 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758579Ab1E0ABi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 20:01:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=UMfcTFKG9L6zBhEWSdJ7jXwPmEArepgt73clQjWXmbjcHNcJFXu/4Q7kquWQdhJ9Is
         Q6m2dG2q9xeWSOQG8sIw5Er76bIb+Drt7lmYAej6wh5jcBWtDvFdlqBideIp5/CSnxPq
         C0AuXTpLR1r6/npaFOUcno8N/TrZAOuJfRvgE=
MIME-Version: 1.0
In-Reply-To: <87k4ddiglp.fsf@ti.com>
References: <201105181047.17309.arnd@arndb.de>
	<87k4ddiglp.fsf@ti.com>
Date: Fri, 27 May 2011 09:01:37 +0900
X-Google-Sender-Auth: FvsvVrRpVpEvtPPx3NY0E7uN1zk
Message-ID: <BANLkTinBZs_bQF-dYM8S=6HSr0o+aDsKKA@mail.gmail.com>
Subject: Re: [RFC] ARM Subarchitecture group maintainership
From: Kyungmin Park <kmpark@infradead.org>
To: Kevin Hilman <khilman@ti.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Nicolas Pitre <nico@fluxnic.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Kyungmin Park <kyungmin.park@samsung.com>

from Samsung Mobile & DMC codes

On Fri, May 27, 2011 at 1:14 AM, Kevin Hilman <khilman@ti.com> wrote:
> Arnd Bergmann <arnd@arndb.de> writes:
>
>> This is the draft plan for maintaining the ARM subarchitectures in a common
>> tree, as a way to help coordinate the upstream merging of the
>> arch/arm/{plat,mach}-* changes into Linus' tree.
>
> [...]
>
>>
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>> Cc: Nicolas Pitre <nico@fluxnic.net>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Russell King <linux@arm.linux.org.uk>
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: linux-kernel@vger.kernel.org
>>
>> ---
>>
>> Maintainers: If you are happy with the layout of the process,
>> please ack this patch, otherwise please comment.
>
> Acked-by: Kevin Hilman <khilman@ti.com>
>
> for davinci and OMAP stuff I maintain.
>
> Kevin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
