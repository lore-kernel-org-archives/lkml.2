Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891Ab0FHChK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 22:37:10 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:37937 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab0FHChI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 22:37:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=WtCCLrFcuPx8T1O/mAwJCue5P54ROMpBluR2fB/L2M+rslccli9f/vSK/FV86BRC2b
         eFdLCZDofiS1UNz2p64sVt97GYu35H9BzlOK+taRzzVljYWaRNJUT4MKP1K5XHISU/18
         W7LTquflAn61UBcf4R5ljf7vYqgvc7cHTjkcw=
MIME-Version: 1.0
In-Reply-To: <4C0DA955.7020802@sandeen.net>
References: <AANLkTinQatQEYahpkN3bT-S5C41HqRoH--gTrvIbGs_c@mail.gmail.com>
	<4C0D5DCD.5010201@sandeen.net>
	<AANLkTik1T2nJxsoK9UGIVy6q6pfSxniFfJXJY0InmuUh@mail.gmail.com>
	<AANLkTil4FMnGl7llR4N0PkXuNyEClQmTspNK6PT62PAi@mail.gmail.com>
	<889B6B31-A1F0-438D-B782-DBB855912854@sandeen.net>
	<AANLkTilrmEnLrxRSYNnwr8vFaZi7R9U5vY39NmBWUEMy@mail.gmail.com>
	<C4177A0B-9A74-40E6-9A58-64418034232C@sandeen.net>
	<AANLkTinzZkN9agekI5eqzA9hERsghI7yDJyAy1O755dr@mail.gmail.com>
	<4C0DA955.7020802@sandeen.net>
Date: Mon, 7 Jun 2010 20:37:06 -0600
Message-ID: <AANLkTil3D5w9Cg2_8GmFa-i0szYmhAu61AXdaLvwp3xv@mail.gmail.com>
Subject: Re: EXT3 File System Corruption 2.6.34
From: Jeffrey Merkey <jeffmerkey@gmail.com>
To: Eric Sandeen <sandeen@sandeen.net>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cool.  I'll use that from now on.  wonder if the source code came from
xdump 10 years ago ... LOL

:)

Jeff

On Mon, Jun 7, 2010 at 8:22 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> Jeffrey Merkey wrote:
>> Well, I will set this as default from now on.  Tell Evil Emperor Linus
>> to put the fucking thing back the way it was so default kernel builds
>> are not fucked up.
>
> ... it was a long discussion I won't re-hash.
>
>
>> Jeff
>>
>> here is the source to the xdump.c file.  may be useful in the future
>> to someone who needs a tool to dump files to post to the list.  Anyway
>> -- easier to use than that fucking hexedit program.
>>
>> :-)
>>
>
>
> you don't like hexdump -C?  more or less the same.
>
> # hexdump -C a8866020.pdf  | more
> 00000000  25 50 44 46 2d 31 2e 32  0d 0a 25 e2 e3 cf d3 0d  |%PDF-1.2..%.....|
> 00000010  0a 32 20 30 20 6f 62 6a  0d 0a 3c 3c 0d 0a 2f 4c  |.2 0 obj..<<../L|
> 00000020  65 6e 67 74 68 20 31 37  32 37 34 0d 0a 2f 46 69  |ength 17274../Fi|
> 00000030  6c 74 65 72 20 2f 46 6c  61 74 65 44 65 63 6f 64  |lter /FlateDecod|
> 00000040  65 0d 0a 3e 3e 0d 0a 73  74 72 65 61 6d 0d 0a 48  |e..>>..stream..H|
> .....
>
> -Eric
>
