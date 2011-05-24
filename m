Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932237Ab1EXTtl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 15:49:41 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:34238 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756576Ab1EXTtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 15:49:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=POppq8/veAjTk7ynxmOI7Bj/193tb1Z8hRuWiAhJVOG6vSUDDdd9A9OrGxDcemj+QS
         VrfGfGUndIduL/5tvDrEvjaTjb7odfonPjbgcQDKcmMii3oOYRKQBp2SdDIzltuIN5Ie
         lQ8v/cJHZx6orKMqieYtQfuzVd+H5kvKVKN9s=
MIME-Version: 1.0
In-Reply-To: <20110524192949.GH6561@elte.hu>
References: <E1QOrld-0003II-DP@eag09.americas.sgi.com>
	<20110524151910.GA23496@elte.hu>
	<BANLkTiknsRgnkM=pQhAzFDe_uCWG-Du7hw@mail.gmail.com>
	<20110524192949.GH6561@elte.hu>
Date: Tue, 24 May 2011 22:49:39 +0300
X-Google-Sender-Auth: pNPP7E3Rbg5i6tQ9N6Hdbtk6h0I
Message-ID: <BANLkTi=pKaKcy41=wV0qEt_dv7hd8Dd2eg@mail.gmail.com>
Subject: Re: [PATCH v5] x86: UV uv_tlb.c cleanup
From: Pekka Enberg <penberg@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Cliff Wickman <cpw@sgi.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 10:29 PM, Ingo Molnar <mingo@elte.hu> wrote:
> Well, yeah, but there were so many cleanliness problems with that code that i
> think we are better off with having this big cleanup over and then start
> working with small, self-contained cleanups and improvements.

Oh, sure, I just wanted to share my unwanted (but free) advice on how
to avoid this kind of mess in the future. ;-)
