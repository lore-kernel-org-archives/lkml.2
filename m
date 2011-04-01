Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758787Ab1DAW3X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 18:29:23 -0400
Received: from smtp-out.google.com ([216.239.44.51]:59832 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758588Ab1DAW3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 18:29:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=HuIXuxMXoLFCx7lJ7jb+LtRZH3mt5sWq6HM+hC1OJzO7HaDB7Gdco3wyqJRstWtrRj
         buNjUYAn+YSg5M3t4OhA==
MIME-Version: 1.0
In-Reply-To: <4D959058.7010606@codeaurora.org>
References: <1301602523-9906-1-git-send-email-omar.ramirez@ti.com>
	<BANLkTimtAcPLmcFKoHkCtWcJipy+rSSP+A@mail.gmail.com>
	<4D959058.7010606@codeaurora.org>
Date: Fri, 1 Apr 2011 15:29:08 -0700
X-Google-Sender-Auth: SnSMKK0dSmg26psT-NuL-QnvDU0
Message-ID: <BANLkTim8GhUAZ7L-MiJiqi6xM=P_Q8kqfg@mail.gmail.com>
Subject: Re: [PATCH] ARM: BUG() dies silently
From: Simon Glass <sjg@chromium.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Omar Ramirez Luna <omar.ramirez@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        lk <linux-kernel@vger.kernel.org>,
        lak <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

Sorry for the confusion, but in fact I was talking about the patch to
make ARM use the generic bug handling via an undef instruction instead
of calling ______bug() or writing to memory address 0. Please see
here:

http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=6808/1

Regards,
Simon

On Fri, Apr 1, 2011 at 1:44 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> On 3/31/2011 6:47 PM, Simon Glass wrote:
>> You might try the generic bug patch and see if it also fixes this
>> problem - Simon
>
> It probably won't because presumably Omar has CONFIG_BUG=n otherwise
> Omar would have sent a patch against __bug() in arch/arm/kernel/traps.c
>
> --
> Sent by an employee of the Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
>
>
