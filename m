Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445Ab0KKDkq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 22:40:46 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39755 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756719Ab0KKDkp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 22:40:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WYUYatOrEqqTYgeABCsO60C+1UyGn2waTq4z6DWxnynUxB73M4D2nVRtspjzfOAG1M
         NxqGGvy7cc1eKilUGw6Lj/XKwTyj39rbQlvmsgYE6KYTeQ4/7wI5JrZoKm2Y38S4bs4j
         /Mv1niyOVD0XvShu4biX8vWHZ/winufo8484s=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1011102257400.11302@swampdragon.chaosbits.net>
References: <1289423173-7044-1-git-send-email-oskar@scara.com>
	<alpine.LNX.2.00.1011102257400.11302@swampdragon.chaosbits.net>
Date: Wed, 10 Nov 2010 21:40:43 -0600
Message-ID: <AANLkTin17WOAqyid2T_byvjCN7ADespHDOEMd8Ewtibk@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix another memleak, in cifs_root_iget
From: Steve French <smfrench@gmail.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Oskar Schirmer <oskar@scara.com>, Steve French <sfrench@samba.org>,
        stable@kernel.org, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Suresh Jayaraman <sjayaraman@suse.de>,
        Andrew Hendry <andrew.hendry@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch is obviously correct.   Merged.

On Wed, Nov 10, 2010 at 3:59 PM, Jesper Juhl <jj@chaosbits.net> wrote:
> On Wed, 10 Nov 2010, Oskar Schirmer wrote:
>
>> cifs_root_iget allocates full_path through
>> cifs_build_path_to_root, but fails to kfree it upon
>> cifs_get_inode_info* failure.
>>
>> Make all failure exit paths traverse clean up
>> handling at the end of the function.
>>
>> Signed-off-by: Oskar Schirmer <oskar@scara.com>
>> Cc: stable@kernel.org
>
> I've reviewed your patch (although not actually tested it) and your
> changes look sane.
> So, feel free to add
>
> Reviewed-by: Jesper Juhl <jj@chaosbits.net>
>
>
> --
> Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
> Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
> Plain text mails only, please.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Thanks,

Steve
