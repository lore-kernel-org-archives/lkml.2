Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab0KHCWv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 21:22:51 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54094 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681Ab0KHCWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 21:22:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=fsQA2dyX0FMPFiLs5AL2mpUE3NaTzOXX5Q5sk+TgpWLx0Ad50nWGeMLhUfuvi10NX9
         JuuLg1wARNBBz/0uDWQBre543XCTCam60XCWoG0hvadj5I179CQ4ez3+RUQ9K7Dkn094
         e1m1zlFN80AWoGxymYkDSkHpz5xEiaSLYrwjA=
MIME-Version: 1.0
In-Reply-To: <20101108014256.GB24260@kroah.com>
References: <01784A8B-36A0-4E8A-9729-23C2B19351F8@mac.com>
	<AANLkTi=UxhRdcDaoKaYVWhPkp_e-uLF4=zhXs7gutkgx@mail.gmail.com>
	<20101106181202.GA6927@kroah.com>
	<39580686-A899-4689-BAAD-AF5546B34E49@mac.com>
	<AANLkTimVsUsrmTvsHqFiqJh1hhryMBemGyW+kYLKGgEu@mail.gmail.com>
	<20101107155757.GA13736@kroah.com>
	<AANLkTik=UWwRLOaHMfVifYiQPpSwoYuA6J1EoL5BOgJY@mail.gmail.com>
	<20101107215908.GA21070@kroah.com>
	<AANLkTimMpGiEHgx03k22wiH-1uzAL-KJm3GADe4bBF_J@mail.gmail.com>
	<20101108014256.GB24260@kroah.com>
Date: Sun, 7 Nov 2010 21:22:49 -0500
Message-ID: <AANLkTiktWubQbH1Q+82kpmM-60nsAwbsZ-46Q3ickX9S@mail.gmail.com>
Subject: Re: Forked android kernel development from linux kernel mainline
From: Arnaud Lacombe <lacombar@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Anca Emanuel <anca.emanuel@gmail.com>, Elvis Dowson <elvis.dowson@mac.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Nov 7, 2010 at 8:42 PM, Greg KH <greg@kroah.com> wrote:
> On Sun, Nov 07, 2010 at 06:09:33PM -0500, Arnaud Lacombe wrote:
>> >Why don't they?
>> >
>> I just checked with some dev on IRC, there might be a time issue. The
>> patches have been synced with 2.6.36 recently (a month ago). So
>> there're still hope :)
>
> Have a pointer to the patch?
>
It is split between new files, under target/linux/ar71xx of their
tree, and patches of existing kernel files. You can browse online the
git export of their SVN:

http://nbd.name/gitweb.cgi?p=openwrt.git;a=tree;f=target/linux/ar71xx;hb=b45b193b99d0111a70845c02bdeb3ece58fb15a1

or clone the git export (~90M):

git://nbd.name/openwrt.git

I guess with some git-fuu, everything can be extracted, so that the
history of the files themselves would be kept, thought, commit message
may need a bit of tweaking. Then patch linking the core to the rest of
the kernel can be applied separately. I'll try to have a look tonight.

 - Arnaud

> thanks,
>
> greg k-h
>
