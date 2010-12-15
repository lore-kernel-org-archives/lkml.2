Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092Ab0LOTZU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 14:25:20 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:43486 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754733Ab0LOTZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 14:25:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=gSxftgjw1o6cu/uYcLsY9g9MPhC/lj1fKB5nRlKtuGNsMGC5E3eL9gYVEM5SwSMeZB
         xbpz3SEodFnbCqR8EVSm2xrPfTNaubTDWO5FZihyd+oDb7X7JxDKg8UcY489XdJ1jTzJ
         0ii2VEAGTh9J0z1xU+ug6APrA0AITnOAzi9/s=
MIME-Version: 1.0
In-Reply-To: <20101215191655.GA6163@basil.fritz.box>
References: <AANLkTinMt6saGeeX3MbwAzZ-+f6AL5BegeFqyPgGwiDo@mail.gmail.com>
	<AANLkTi=cn04WZGMnVX6ie5PSM+9v0tJSSg0kD8_W5N11@mail.gmail.com>
	<20101212023415.GG3059@thunk.org>
	<AANLkTim=i8wDnML+K4uGK_neNDCiWxtKGDx01O+3joaE@mail.gmail.com>
	<AANLkTinhHTqqpP=pQ8Foyc9xeaZi65GHGHGY51OyZtvF@mail.gmail.com>
	<20101212124354.GA4513@thunk.org>
	<AANLkTikZkCs7Wee2=uhe3bw96Pggcv0jsCkZ+nkWEQ+=@mail.gmail.com>
	<20101213020657.GB4513@thunk.org>
	<AANLkTinMWS-yyzWJ3oBo_KS9jXt4p4pveo+SPTLiWnCt@mail.gmail.com>
	<AANLkTimjM_HptLaCSuQivxruWpoc7todyMe0wnszrSYU@mail.gmail.com>
	<20101215191655.GA6163@basil.fritz.box>
Date: Wed, 15 Dec 2010 20:25:14 +0100
Message-ID: <AANLkTi=9fbou9YF2bXzrWbBM37F4_Xyi-KgWquq0PrBL@mail.gmail.com>
Subject: Re: hunt for 2.6.37 dm-crypt+ext4 corruption? (was: Re: dm-crypt
 barrier support is effective)
From: Matt <jackdachef@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: "Ted Ts'o" <tytso@mit.edu>, Jon Nelson <jnelson@jamponi.net>,
        Chris Mason <chris.mason@oracle.com>,
        Mike Snitzer <snitzer@redhat.com>, Milan Broz <mbroz@redhat.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        dm-devel <dm-devel@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        htd <htd@fancy-poultry.org>, htejun <htejun@gmail.com>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 15, 2010 at 8:16 PM, Andi Kleen <andi@firstfloor.org> wrote:
>> I have a question though: the deactivation of multiple page-io
>> submission support most likely only would affect bigger systems or
>> also desktop systems (like mine) ?
>
> I think this is not a final fix, just a workaround.
> The problem with the other path still really needs to be tracked down.
>
> -Andi
>
> --
> ak@linux.intel.com -- Speaking for myself only.
>

ok,

thanks for the clarification

Regards

Matt
