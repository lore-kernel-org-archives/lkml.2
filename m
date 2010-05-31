Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672Ab0EaOQZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 10:16:25 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:40434 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755236Ab0EaOQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 10:16:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=XhTmuyfqwsLg+u0cs4VUC0V2C7IybLPf31JTfjXx0XcgCbu1GUG0STk+12vY1w6cRH
         EmvOLWHq42GtdC2T249zMO0f91CNz2Oc9MYVnqj1qYLdYnc0nVX6sFnVfG3OtyMxEAel
         Qy194HfMnEt71Nwhi49FVBzSld/Kog/yQdlUw=
Subject: Re: [PATCH] netfilter: xtables: stackptr should be percpu
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Xiaotian Feng <dfeng@redhat.com>, netfilter-devel@vger.kernel.org,
       netfilter@vger.kernel.org, coreteam@netfilter.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Patrick McHardy <kaber@trash.net>,
       "David S. Miller" <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alexey Dobriyan <adobriyan@gmail.com>
In-Reply-To: <alpine.LSU.2.01.1005311608570.20623@obet.zrqbmnf.qr>
References: <1275303998-2435-1-git-send-email-dfeng@redhat.com>
	 <alpine.LSU.2.01.1005311350580.31799@obet.zrqbmnf.qr>
	 <1275311580.3291.44.camel@edumazet-laptop>
	 <alpine.LSU.2.01.1005311519340.25402@obet.zrqbmnf.qr>
	 <1275313448.3291.49.camel@edumazet-laptop>
	 <alpine.LSU.2.01.1005311608570.20623@obet.zrqbmnf.qr>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 May 2010 16:16:12 +0200
Message-ID: <1275315372.3291.51.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 31 mai 2010 à 16:09 +0200, Jan Engelhardt a écrit :

> Keep your friends close, and your enemies closer ;-)
> 
> 	git describe --contains f3c5c1bfd


Yes, --contains should be the default, and --predates the option :)

This is a bit OT anyway :)


