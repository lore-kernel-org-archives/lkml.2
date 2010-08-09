Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213Ab0HIGoo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 02:44:44 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60342 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989Ab0HIGon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 02:44:43 -0400
Date: Mon, 9 Aug 2010 08:44:41 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: remove __phys_reloc_hide
Message-ID: <20100809064441.GC29524@basil.fritz.box>
References: <1281303490-390-1-git-send-email-namhyung@gmail.com>
 <87k4o08fv9.fsf@basil.nowhere.org>
 <1281336031.976.11.camel@leonhard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281336031.976.11.camel@leonhard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm not talking about the RELOC_HIDE itself. I do know we need it for
> some specific case, ie. percpu. But in this case __pa_symbol(x) is
> expanded to RELOC_HIDE((unsigned long)(x), 0) which does nothing
> meaningful. I believe the overflow is not a concern here.

It hides the value conversion from the compiler through asm()

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
