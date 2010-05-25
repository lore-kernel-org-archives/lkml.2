Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759Ab0EYI1h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 04:27:37 -0400
Received: from 88-97-16-53.dsl.zen.co.uk ([88.97.16.53]:54043 "EHLO
	andromeda.kingswood-consulting.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753842Ab0EYI1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 04:27:36 -0400
Message-ID: <4BFB89F4.8090104@kingswood-consulting.co.uk>
Date: Tue, 25 May 2010 09:27:32 +0100
From: Frank Kingswood <frank@kingswood-consulting.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100411 Lightning/1.0b1 Icedove/3.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 2.6.34: arch/x86/Kconfig BUG  (was: SCHED_OMIT_FRAME_POINTER configuration
 option wrong)
References: <ht3riv$b5f$1@dough.gmane.org>
In-Reply-To: <ht3riv$b5f$1@dough.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/05/10 18:30, Frank A. Kingswood wrote:
> Hi!
>
> The configuration option SCHED_OMIT_FRAME_POINTER seems to have gained a
> most unusual description in 2.6.34.
>
> 490 config SCHED_OMIT_FRAME_POINTER
> 491 def_bool y
> 492 prompt "Single-depth WCHAN output"
> 493 depends on X86
> 494 ---help---
> 495 Calculate simpler /proc/<PID>/wchan values. If this option
> 496 is disabled then wchan values will recurse back to the
> 497 caller function. This provides more accurate wchan values,
> 498 at the expense of slightly more scheduling overhead.
> 499
> 500 If in doubt, say "Y".

This looks like a git merge error/bug.

Frank
