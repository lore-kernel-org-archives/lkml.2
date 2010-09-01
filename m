Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693Ab0IAJmF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 05:42:05 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:36144 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753740Ab0IAJmA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 05:42:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=xtdsz3jRo7LJX4+ah+ynAf4sgPrbbUVGwav4jHh0kc+Y7UxZVG7B3mezVgRgJyA2xs
         jfKjU/ENPQq2Fe1pos4n7thOBtBcGvcdm60muYd9+ryU3SJeAC5EX1VL/+OMdIbN7m8u
         FPR3tg5kpb1Eu+7mHF+j5x+6rP34wSqo5Nq+4=
MIME-Version: 1.0
In-Reply-To: <20100901113525.04b356c5@tux.DEF.witbe.net>
References: <20100901113525.04b356c5@tux.DEF.witbe.net>
Date: Wed, 1 Sep 2010 12:41:59 +0300
X-Google-Sender-Auth: NnSa8rWgVmZH_BCU7RkhNHoft3I
Message-ID: <AANLkTimnBG1qcLwZoEkr_iDkwE4zygLdjFJHVk9S3+wZ@mail.gmail.com>
Subject: Re: 2.6.36-rc2 : slabtop report 10170292 size-32 objects...
From: Pekka Enberg <penberg@kernel.org>
To: Paul Rolland <rol@as2917.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Dave Airlie <airlied@linux.ie>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 1, 2010 at 12:35 PM, Paul Rolland <rol@as2917.net> wrote:
> I was surprised to see my machine using so much swap when I couldn't find
> where all the memory was gone, and I checked quickly what slabtop had to
> say, and found that one :
>
>  OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME
> 10172288 10171996  99%    0.03K  90824      112    363296K size-32
>
> That makes is 10M active "size-32" entries ? but what is that ? What is
> using the "size-32" ? And it this normal to see that on a laptop with 4G
> RAM which is only running X, KDE, Compiz+emerald, +/-10 xterms and a
> firefox which is closed as soon as it is no more used.
>
> Before you ask :
> [root@tux proc]# zgrep SLAB /proc/config.gz
> CONFIG_SLAB=y
> CONFIG_SLABINFO=y
> # CONFIG_DEBUG_SLAB is not set
> [root@tux proc]# uptime
>  11:34:50 up 6 days, 20:30, 13 users,  load average: 1.42, 1.35, 1.23
>
> so that may limit the actions or informations I can collect, but any
> details you want, please feel free to ask.

Might be related to this:

http://kerneltrap.org/mailarchive/linux-kernel/2010/8/25/4611329
