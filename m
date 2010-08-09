Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629Ab0HIHrf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 03:47:35 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:61969 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755462Ab0HIHre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 03:47:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=OdC5aGOBApiVwl/GyFTiopgoCGDza28ZBKKxhk9mzCK7V7kFphaJIggRcAZfg43g8/
         nbPx18xvnVf6/W3qIyhZY8+spobPKjzNXg2ZVU/c0wimiNvo7X2x9LchbhkykV8EYeJ+
         rjP1Ob7cfwtjheJBFoAQeE8SFokINYzp9iQ4o=
Subject: Re: [PATCH] x86: remove __phys_reloc_hide
From: Namhyung Kim <namhyung@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20100809072226.GD29524@basil.fritz.box>
References: <1281303490-390-1-git-send-email-namhyung@gmail.com>
	 <87k4o08fv9.fsf@basil.nowhere.org> <1281336031.976.11.camel@leonhard>
	 <20100809064441.GC29524@basil.fritz.box> <1281337485.976.24.camel@leonhard>
	 <20100809072226.GD29524@basil.fritz.box>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Aug 2010 16:47:39 +0900
Message-ID: <1281340059.976.27.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010-08-09 (월), 09:22 +0200, Andi Kleen:

> The original reason was that the C standard allows the compiler
> to make some assumptions on the pointer arithmetic that is done 
> on symbol addresses (e.g. no wrapping). This is exploited
> by the optimizer in the compiler to generate better code.
> 
> This lead to a miscompilation on PowerPC a couple of years back at 
> least with the va->pa conversion.
> 
> After that RELOC_HIDE was introduced after funelling the
> symbol address through an empty asm statement was recommended 
> as the official way to do this by the gcc developers.
> 
> I think x86-64 does not normally wrap here, but it's 
> still safer to do it this way.
> 
> -Andi

OK, then. Thanks for the comment.

p.s. The funny thing I found is there's no use of RELOC_HIDE on
arch/powerpc. Hmm...

-- 
Regards,
Namhyung Kim


