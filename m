Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521Ab1GDOSj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 10:18:39 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:30930 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981Ab1GDOSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 10:18:38 -0400
Subject: Re: [PATCH 2/2] asm-generic: move archictures to common delay.h
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
To: Jonas Bonn <jonas@southpole.se>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        lethal@linux-sh.org
In-Reply-To: <1309600754-21217-2-git-send-email-jonas@southpole.se>
References: <1309600754-21217-1-git-send-email-jonas@southpole.se>
	 <1309600754-21217-2-git-send-email-jonas@southpole.se>
Content-Type: text/plain; charset="UTF-8"
Organization: Atmel Corporation
Date: Mon, 04 Jul 2011 16:18:08 +0200
Message-ID: <1309789088.4373.26.camel@hcegtvedt.norway.atmel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Jul 2011 14:18:11.0715 (UTC) FILETIME=[34AAED30:01CC3A55]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-07-02 at 11:59 +0200, Jonas Bonn wrote:

Hello Jonas,

Please use the latest email address from MAINTAINERS, I will only have
access to my Atmel account for one more week.

> This patch moves the in-tree architectures that were using the 'generic'
> delay.h over to using the header file in asm-generic.
> 
> This is not done using the generic-y mechanism as none of these arch's
> have started using that mechanism yet.  This is a trivial change to make
> later when the arch begins using generic-y.
> 
> Note the subtle change to the avr32 and SH architectures where the argument
> to __const_udelay was previously using the rounded down constant value
> instead of the rounded up value.

My guess is that the AVR32 implementation is copied from x86, hence the
Copyright to Linus. Thanks for cleaning up.

> Signed-off-by: Jonas Bonn <jonas@southpole.se>
>

Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>

<snipp>

-- 
Hans-Christian Egtvedt

