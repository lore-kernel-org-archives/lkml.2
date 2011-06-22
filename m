Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab1FVIiB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 04:38:01 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:58593 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754367Ab1FVIh5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 04:37:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=nkv154YLlW2kHGsPLWezSlCssL44LQAFYwKMNL27rKBrnUEca3Z99xWE7qtBu9e8+8
         3KWl8RoH4bOUfIk8FFGTqoV1zibF6VjfJM7g/aPjFC2x9GwuCP3DYviToBWl1HAUttU3
         GLgBorN9akaAgGewhwb52zyS1aRLRR8GvUrZs=
MIME-Version: 1.0
In-Reply-To: <4E018CE3.7070101@snapgear.com>
References: <20110622111256.3857df1e.sfr@canb.auug.org.au>
	<4E018CE3.7070101@snapgear.com>
Date: Wed, 22 Jun 2011 10:29:41 +0200
X-Google-Sender-Auth: k1BHIlMX7B5oXnIA09VBPOWNTbk
Message-ID: <BANLkTinswxRuM52vW7acZrsKgpMrSxMuWA@mail.gmail.com>
Subject: Re: linux-next: manual merge of the m68knommu tree with the m68k tree
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg Ungerer <gerg@snapgear.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Linux/m68k" <linux-m68k@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg, Stephen,

On Wed, Jun 22, 2011 at 08:34, Greg Ungerer <gerg@snapgear.com> wrote:
> On 22/06/11 11:12, Stephen Rothwell wrote:
>> Today's linux-next merge of the m68knommu tree got a conflict in
>> arch/m68k/include/asm/bitops_mm.h between commit 17c74432b88e
>> ("m68k/bitops: Make bitmap data pointer of atomic ops volatile") from the
>> m68k tree and commit 2cb0d89e66b1 ("m68k: merge mmu and non-mmu
>> bitops.h") from the m68knommu tree.
>>
>> The latter effectively deletes in the file and in doing the merge,
>> removes the funtions that were modified by the former commit.  So I just
>> removed the file.
>
> That would be right. The changes that Geert's patch makes are in
> my merge patch.

Sorry, I forgot that Greg was merging them, which also fixes the issue we
had on m68k.

[mental note to self: check for merge conflicts with m68knommu before updating
 for-next]

> Geert: do you want me to hold of on merging the bitops.h files?

No, it looks fine to me. Feel free to add my Acked-by.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
