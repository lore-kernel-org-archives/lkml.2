Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795Ab2BOT6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 14:58:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10137 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753264Ab2BOT6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 14:58:18 -0500
Message-ID: <1329335879.2337.18.camel@localhost>
Subject: Re: [PATCH] ARM: ptrace: Include linux/audit.h to fix build errors
From: Eric Paris <eparis@redhat.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        Nathaniel Husted <nhusted@gmail.com>,
        Will Deacon <will.deacon@arm.com>,
        Dave Martin <dave.martin@linaro.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        linux-arm-kernel@lists.infradead.org
Date: Wed, 15 Feb 2012 14:57:59 -0500
In-Reply-To: <20120215173443.GF27825@n2100.arm.linux.org.uk>
References: <1329284188.12708.1.camel@phoenix>
	 <20120215083609.GD13673@n2100.arm.linux.org.uk>
	 <1329325622.2337.13.camel@localhost>
	 <20120215173443.GF27825@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-15 at 17:34 +0000, Russell King - ARM Linux wrote:
> On Wed, Feb 15, 2012 at 12:07:02PM -0500, Eric Paris wrote:
> > So if someone tells me how the code knows it's endianness I'll gladly
> > write the ifdef to switch from AUDIT_ARCH_ARMEB to AUDIT_ARCH_ARM when
> > appropriate....
> 
> An easy way would be:
> 
> #ifndef __ARMEB__
> #define AUDIT_ARCH_NR AUDIT_ARCH_ARMEB
> #else
> #define AUDIT_ARCH_NR AUDIT_ARCH_ARM
> #endif

Is that actually exactly backwards?  ifndef?  (I don't have a clue when
__ARMEB__ is set)

