Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932437Ab0HJRJn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 13:09:43 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:47613 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932253Ab0HJRJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 13:09:40 -0400
Subject: Re: [PATCH 05/10] ARM: ftrace: add ENDPROC annotations
From: Catalin Marinas <catalin.marinas@arm.com>
To: Rabin Vincent <rabin@rab.in>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Abhishek Sagar <sagar.abhishek@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <20100421192319.GA16719@debian>
References: <20100421192319.GA16719@debian>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Tue, 10 Aug 2010 18:07:52 +0100
Message-ID: <1281460072.16880.47.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Aug 2010 17:07:52.0982 (UTC) FILETIME=[91AEFB60:01CB38AE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rabin,

On Wed, 2010-04-21 at 20:23 +0100, Rabin Vincent wrote:
> From 87b70ed633da00fe9873a5819c6d24e57368de43 Mon Sep 17 00:00:00 2001
> From: Rabin Vincent <rabin@rab.in>
> Date: Sun, 14 Feb 2010 01:18:33 +0530
> Subject: [PATCH] ARM: ftrace: add ENDPROC annotations
> 
> When building as Thumb-2, the ".type foo, %function" annotation in
> ENDPROC seems to be required in order for the assembly routines to be
> recognized as Thumb-2 code.  If the ENDPROC annotations are not present,
> calls to these routines are generated as BLX instead of BL.
> 
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Rabin Vincent <rabin@rab.in>

What's the status of these patches? I haven't seen them in mainline.

Thanks.

-- 
Catalin

