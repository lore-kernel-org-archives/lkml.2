Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab0HISom (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 14:44:42 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53307 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754500Ab0HISok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 14:44:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=roli35UC9HAgMMnyDwjms2j613I8JNgAh0JMEMk2ScyTG9V0J6I4PYogKfBUdmun0p
         SsxCDkLrb6l0EqEQBzje+D0x3Mmd/IBngkEMUCW+CoOIPSW6/ZPGGH4+4q080RCoyRP+
         pxUhedgeQix+GmlIdauc2cmrLd58CtqbTEjnE=
MIME-Version: 1.0
In-Reply-To: <1281374816-904-4-git-send-email-ngupta@vflare.org>
References: <1281374816-904-1-git-send-email-ngupta@vflare.org>
	<1281374816-904-4-git-send-email-ngupta@vflare.org>
Date: Mon, 9 Aug 2010 21:44:39 +0300
X-Google-Sender-Auth: cUsQNSymFbX31abYjN_vvaw52QA
Message-ID: <AANLkTimC=YGQKDmjsYir7iUwc9AtfkmJrcrrNptk0wZz@mail.gmail.com>
Subject: Re: [PATCH 03/10] Use percpu stats
From: Pekka Enberg <penberg@kernel.org>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Linux Driver Project <devel@driverdev.osuosl.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 9, 2010 at 8:26 PM, Nitin Gupta <ngupta@vflare.org> wrote:
> Also remove references to removed stats (ex: good_comress).
>
> Signed-off-by: Nitin Gupta <ngupta@vflare.org>

Acked-by: Pekka Enberg <penberg@kernel.org>
