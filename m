Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697Ab1C1H05 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 03:26:57 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65393 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab1C1H04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 03:26:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=EPJpoick4lUOOxH+38jrQech9NuT8WHgxAIn+UxfEI/pProF7XVp+i9u3zeFGb87+J
         Sz9PUAIxDGRigqSZiQQEo/D65eiy3EQAux5qZr7nCv/oGATOdOg3mwpi6955rhnDTNgR
         tNrryuWIGptj4MRXHescYeeqgQVzFbfVnOR6E=
Subject: Re: [PATCH] slub: Disable the lockless allocator
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@kernel.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Christoph Lameter <cl@linux.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, akpm@linux-foundation.org,
        tj@kernel.org, npiggin@kernel.dk, rientjes@google.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20110328063656.GA29462@elte.hu>
References: <1301161507.2979.105.camel@edumazet-laptop>
	 <alpine.DEB.2.00.1103261406420.24195@router.home>
	 <alpine.DEB.2.00.1103261428200.25375@router.home>
	 <alpine.DEB.2.00.1103261440160.25375@router.home>
	 <AANLkTinTzKQkRcE2JvP_BpR0YMj82gppAmNo7RqgftCG@mail.gmail.com>
	 <alpine.DEB.2.00.1103262028170.1004@router.home>
	 <alpine.DEB.2.00.1103262054410.1373@router.home>
	 <4D9026C8.6060905@cs.helsinki.fi> <20110328061929.GA24328@elte.hu>
	 <AANLkTinpCa6GBjP3+fdantvOdbktqW8m_D0fGkAnCXYk@mail.gmail.com>
	 <20110328063656.GA29462@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Mar 2011 09:26:50 +0200
Message-ID: <1301297210.32248.6.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 28 mars 2011 à 08:36 +0200, Ingo Molnar a écrit :

> I think we might still be missing the hunk below - or is it now not needed 
> anymore?


Its not needed anymore, once cmpxchg16b implementation works correctly
on !SMP build. (It does now with current linux-2.6 tree)



