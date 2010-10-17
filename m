Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826Ab0JQIBJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 04:01:09 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52051 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754863Ab0JQIBH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 04:01:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=SGuuAD/puxkf8Or26d3uI6BVRH5EVB3SPfjKwL79gP9U2m6Y4ZzkrPOerBUu1/MJH8
         frFm8NfzyK0/9e55aTR9Ewmx7133dLOk/CPFrq7D8f1Cn9XBV11BbKHEHAq5lkbP4SYR
         sG5RGt3qo4aONm7+4a3M4uD/xpeqCOUDi0aPs=
MIME-Version: 1.0
In-Reply-To: <20101017092621.67ac74e0.sfr@canb.auug.org.au>
References: <alpine.DEB.2.00.1010161656590.12912@ayla.of.borg>
	<alpine.DEB.2.00.1010161722120.30415@ayla.of.borg>
	<20101017092621.67ac74e0.sfr@canb.auug.org.au>
Date: Sun, 17 Oct 2010 10:01:03 +0200
X-Google-Sender-Auth: s-RG6ZCsfNWLfnSWGgZkhmCrnrg
Message-ID: <AANLkTi=ZFUkXebqw9-NUzT48KK58PyaJF7DSpxKJeGm8@mail.gmail.com>
Subject: Re: Build regressions/improvements in v2.6.36-rc8
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 17, 2010 at 00:26, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> On Sat, 16 Oct 2010 17:31:34 +0200 (CEST) Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>> On Sat, 16 Oct 2010, Geert Uytterhoeven wrote:
>> > 162 regressions:
>> >     src/fs/9p/vfs_inode.c: error: implicit declaration of function 'inode_setattr':  => 1267
>> >     src/include/linux/vgaarb.h: error: asm/vga.h: No such file or directory:  => 34:21
>>
>> These two are reported for m68k/allmodconfig:
>> http://kisskb.ellerman.id.au/kisskb/buildresult/3387901/, but I cannot
>> reproduce them.
>
> Neither of those errors are reported in the above build result ...

Strange...

$ wget http://kisskb.ellerman.id.au/kisskb/buildresult/3387901/; grep
inode_set index.html
--2010-10-17 09:59:35--
http://kisskb.ellerman.id.au/kisskb/buildresult/3387901/
Resolving kisskb.ellerman.id.au... 203.10.76.25
Connecting to kisskb.ellerman.id.au|203.10.76.25|:80... connected.
HTTP request sent, awaiting response... 200 OK
Length: 272362 (266K) [text/html]
Saving to: `index.html'

100%[=====================================================================>]
272,362     67.8K/s   in 3.9s

2010-10-17 09:59:39 (67.8 KB/s) - `index.html' saved [272362/272362]

/scratch/kisskb/src/fs/9p/vfs_inode.c:1267: error: implicit
declaration of function &#39;inode_setattr&#39;
$

Yep, it's there.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
