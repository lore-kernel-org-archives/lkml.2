Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360Ab0KAG6K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 02:58:10 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48704 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203Ab0KAG6I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 02:58:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=LsdsjMzG+Tvu/cARi1BsKsz68j0aPzGxCWCyv4wK/3HCTWI8B3hny6TY7qSnkRdS7F
         CpyvtProuuzkpHa0GqF1LcRsTDPWD5JNx5Wm48v4q4QVLrwCWFosAcEyyKANvXpsjk04
         hW++oxEBX/CNQ5ifHeA6TOkMXG3YY+8c9nOQQ=
MIME-Version: 1.0
In-Reply-To: <20101031174635.88f441fe.akpm@linux-foundation.org>
References: <alpine.LNX.2.00.1010302216550.1572@swampdragon.chaosbits.net>
	<20101030214704.GA20005@Krystal>
	<alpine.LNX.2.00.1010302343590.1572@swampdragon.chaosbits.net>
	<20101031183913.GA26160@Krystal>
	<20101031174635.88f441fe.akpm@linux-foundation.org>
Date: Mon, 1 Nov 2010 08:58:07 +0200
X-Google-Sender-Auth: pFIfBGVK-aS39rbI9xNbHeDiwF8
Message-ID: <AANLkTinUMFC9-_n4eXfyQNP6i3-tcDKWx5sBKZmCabJ3@mail.gmail.com>
Subject: Re: [PATCH] Optimize relay_alloc_page_array() slightly by using
 vzalloc rather than vmalloc and memset
From: Pekka Enberg <penberg@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org,
        Tom Zanussi <zanussi@us.ibm.com>, Karim Yaghmour <karim@opersys.com>,
        Paul Mundt <lethal@linux-sh.org>, Steven Rostedt <rostedt@goodmis.org>,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 1, 2010 at 2:46 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> aw, c'mon, read the code.  The patch is good and improves that function
> so much it ain't funny.
>
> It's a non-runtime-tested, obviously-correct cleanup.  Yes, it would be
> better if it was runtime tested.  But we merge patches on this basis
> all the time and it works out OK.
>
> If, amazingly, there is some bug in it then someone will hit that bug in
> -next or -rc testing and we'll fix it.  Shrug.  If you're that worried then
> *you* could runtime test it!

Looks good to me too.

Acked-by: Pekka Enberg <penberg@kernel.org>
