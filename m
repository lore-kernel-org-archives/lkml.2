Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244Ab1DTLsO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 07:48:14 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:47652 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157Ab1DTLsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 07:48:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ndHMT/LFIO79VCAKEWDB4SUexW05yWW+CBEOoZImzNYDmI7T2bLbhIy9GjnBSpH2kI
         DHaslqaucyHhv5Eu7Xcs2snQy1zkyVow7U1FEnonKbeadSusGm/P9JMSKNY4WpGFyPZq
         1W1o3eEiLFTHVU8f53/Ls/RnCIW/4rIb0TMJw=
Subject: Re: [PATCH] mm: make read-only accessors take const parameters
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Phil Carmody <ext-phil.2.carmody@nokia.com>
Cc: ext Christoph Lameter <cl@linux.com>, akpm@linux-foundation.org,
        aarcange@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20110415160701.GE7112@esdhcp04044.research.nokia.com>
References: <1302861377-8048-1-git-send-email-ext-phil.2.carmody@nokia.com>
	 <1302861377-8048-2-git-send-email-ext-phil.2.carmody@nokia.com>
	 <alpine.DEB.2.00.1104150949210.5863@router.home>
	 <20110415160701.GE7112@esdhcp04044.research.nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Apr 2011 14:45:19 +0300
Message-ID: <1303299919.2700.26.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-15 at 19:07 +0300, Phil Carmody wrote:
> Not in C, alas. As it returns what it's given I wouldn't want it to
> lie
> about the type of what it returns, and some of its clients want it to
> return something writeable. 

I think this little lie is prettier than _ro variants of functions. I do
not think you'll go far with your 'const' quest if you start adding _ro
variants for different core functions, but if you just cast the return
pointer to non-const you might be more successful.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

