Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102Ab1DPSyQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 14:54:16 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59891 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425Ab1DPSyF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 14:54:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=U4j4eLVbyqkyCj9BZyiE7HX5qedhw7Jw3ZRJK5X5gvS7FxddLdezEwNkyZ0gmvOFfM
         mu21EmGx43c+LrUioFjlIQp1cvFR9zFwVq8QVvvmd97B+c9l7BcOFuGesdkrGbuVEU3M
         uEcoc4WdgDu5KnNKJ2Xrhnrs2KLnYtyyWFxuY=
MIME-Version: 1.0
In-Reply-To: <20110416163509.GS18463@8bytes.org>
References: <BANLkTik7W0u92n_s0t32dsoLULu4QTZneA@mail.gmail.com>
	<4DA6145D.9070703@kernel.org>
	<BANLkTinud+4nUkZtnYRrU_gAFaMDWRa_AA@mail.gmail.com>
	<4DA655E7.3000904@zytor.com>
	<BANLkTimqR_M5keMqr5WAuz-t+1BkCZbwCg@mail.gmail.com>
	<BANLkTincU4rM+SqhzGOK_Rgxgg8fqJOOdQ@mail.gmail.com>
	<20110415131152.GJ18463@8bytes.org>
	<20110415131650.GB18660@elte.hu>
	<20110415154604.GN18463@8bytes.org>
	<BANLkTim23SQiyb4R+QA7=fpPZrnQw9_PRQ@mail.gmail.com>
	<20110416163509.GS18463@8bytes.org>
Date: Sat, 16 Apr 2011 14:54:04 -0400
Message-ID: <BANLkTimxG3QoLx0vqw9YgE_s4qyzcEoEaQ@mail.gmail.com>
Subject: Re: Linux 2.6.39-rc3
From: Jerome Glisse <j.glisse@gmail.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Tejun Heo <tj@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
        alexandre.f.demers@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 16, 2011 at 12:35 PM, Joerg Roedel <joro@8bytes.org> wrote:
> On Fri, Apr 15, 2011 at 12:11:28PM -0400, Jerome Glisse wrote:
>> Do you also got the write if you load radeon with radeon.no_wb=1 ?
>> I think at this address it's the wb page, or maybe the cp as wb likely
>> take only one page
>
> radeon.no_wb=1 makes no difference. The box still reboots.
>
>        Joerg
>
>

If you want to go the printk way you can add printk before each test
ring_test, ib_test in r600.c this 2 functions are the own that might
trigger the first GPU gart activities.

Cheers,
Jerome
