Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751170Ab1EIEFA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 00:05:00 -0400
Received: from mail.wdtv.com ([66.118.69.84]:49849 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782Ab1EIEE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 00:04:59 -0400
From: gene heskett <gheskett@wdtv.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: trying to build 2.6.38.5?
Date: Mon, 9 May 2011 00:04:55 -0400
User-Agent: KMail/1.13.7 (Linux/2.6.38.5-pclos1.pae.bfs; KDE/4.6.3; i686; ; )
Cc: Connor H <cmdkhh@gmail.com>, linux-kernel@vger.kernel.org
References: <201105082023.09878.gene.heskett@gmail.com> <BANLkTik5uTMRpg5mj2MtnW+MZDgWwOgyUQ@mail.gmail.com> <20110508191536.ba3173d2.rdunlap@xenotime.net>
In-Reply-To: <20110508191536.ba3173d2.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201105090004.56021.gheskett@wdtv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, May 08, 2011, Randy Dunlap wrote:
>On Sun, 8 May 2011 19:00:54 -0700 Connor H wrote:
>> unable to reproduce using the included config file,
>> 
>> Connor
>
>Nor can I.

Thanks for looking, Randy.  I appreciate it.
>
>> On Sun, May 8, 2011 at 6:12 PM, gene heskett <gheskett@wdtv.com> wrote:
>> > On Sunday, May 08, 2011, Randy Dunlap wrote:
>> >>On Sun, 8 May 2011 20:23:09 -0400 Gene Heskett wrote:
>> >>> At the end of a make -j2 all:
>> >>> 
>> >>> /home/gene/src/linux-2.6.38.5-gene/include/linux/Kbuild:25: ***
>> >>> commands commence before first target. �Stop.
>> >>> make[2]: *** [linux] Error 2
>> >>> make[2]: *** Waiting for unfinished jobs....
>> >>> make[1]: *** [headers_install] Error 2
>> >>> make: *** [vmlinux] Error 2
>> >>> 
>> >>> What am I missing?
>> >>
>> >>I can't reproduce this problem. �Please post your kernel .config
>> >>file.
>> >>
>> > Attached, thanks Randy.
>
>---
>~Randy
>*** Remember to use Documentation/SubmitChecklist when testing your code
>***


-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
<http://tinyurl.com/ddg5bz>
<http://www.cantrip.org/gatto.html>
... I have read the INSTRUCTIONS ...
