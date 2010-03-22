Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078Ab0CVUNO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 16:13:14 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57217 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764Ab0CVUNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 16:13:12 -0400
To: James Kosin <jkosin@intcomgrp.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [OT] Style Issues / Concerns
From: Andi Kleen <andi@firstfloor.org>
References: <4BA7CCC5.5020302@intcomgrp.com>
Date: Mon, 22 Mar 2010 21:13:06 +0100
In-Reply-To: <4BA7CCC5.5020302@intcomgrp.com> (James Kosin's message of "Mon, 22 Mar 2010 16:02:13 -0400")
Message-ID: <87wrx45d4d.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Kosin <jkosin@intcomgrp.com> writes:
>
> Before everyone jumps in at once, this is a simple example that will
> produce a compiler error about the misplaced else.  However if there are
> many if statements above this that may allow the else to be paired up
> with it then the code will compile and there will be a serious and very
> difficult bug in the code that will take days or months to find.

Modern editors with auto indent mode makes it actually very easy
to find such bugs.

Also checkpatch.pl checks for it now I believe.

> Does the compiler produce smaller code without the braces {}?

No, it's very arbitary.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
