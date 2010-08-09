Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433Ab0HIHEm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 03:04:42 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:36736 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755039Ab0HIHEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 03:04:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=sfatU30Sr67iUxbqbspVUYpe+DmdpcnQmY8syrhfHUtGeSUmz3uHd8z5jhcziYk4aO
         IV0Dhd5ya3bFCAM4Vp5kvStgYKiu4solC4v9+ispJ/BhRi2W5RVYSDO45sQv9bci8T9B
         6uDuugodaHbiocWjAK9EoKrwEgAczgoakEHxM=
Subject: Re: [PATCH] x86: remove __phys_reloc_hide
From: Namhyung Kim <namhyung@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20100809064441.GC29524@basil.fritz.box>
References: <1281303490-390-1-git-send-email-namhyung@gmail.com>
	 <87k4o08fv9.fsf@basil.nowhere.org> <1281336031.976.11.camel@leonhard>
	 <20100809064441.GC29524@basil.fritz.box>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Aug 2010 16:04:45 +0900
Message-ID: <1281337485.976.24.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It hides the value conversion from the compiler through asm()
> 
> -Andi
> 

Yes, indeed. But for what? __pa_symbol() is just used to get the address
of some linker symbols in forms of unsigned long which has same bit
representation as pointer in x86 (and all supported archs). So do we
still need it or am I missing something?


-- 
Regards,
Namhyung Kim


