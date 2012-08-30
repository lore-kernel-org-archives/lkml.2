Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978Ab2H3PRg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 11:17:36 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:57851 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677Ab2H3PRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 11:17:35 -0400
MIME-Version: 1.0
In-Reply-To: <1346316580.7727.1.camel@localhost.localdomain>
References: <CALCETrW-LFzcHYgx=thQiuTfU8RdRBrtXwE7QboWpNrjz4An4A@mail.gmail.com>
 <1346316580.7727.1.camel@localhost.localdomain>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 30 Aug 2012 08:17:13 -0700
Message-ID: <CALCETrX6zZdVK9UHqstGNPAiXDbeMUMnLxtNrJ7pR=RYOP8iWw@mail.gmail.com>
Subject: Re: Which disk is ata4?
To: Bjoern Franke <bjo@nord-west.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 1:49 AM, Bjoern Franke <bjo@nord-west.org> wrote:
> Am Mittwoch, den 29.08.2012, 21:38 -0700 schrieb Andy Lutomirski:
>> One of my disks went out to lunch for a while.  Logs below.
>
> dmesg | grep ata4
>
> for instance with ata1:
> [root@ostrea][/]# dmesg | grep ata1
> ata1.00: ATA-7: SAMSUNG MP0402H, UC200-16, max UDMA/100

I tried that, too.

$ dmesg |grep ST3000DM001-9YN166
[    1.064910] ata5.00: ATA-8: ST3000DM001-9YN166, CC4B, max UDMA/133
[    1.064926] ata3.00: ATA-8: ST3000DM001-9YN166, CC4B, max UDMA/133
[    1.064986] ata2.00: ATA-8: ST3000DM001-9YN166, CC4B, max UDMA/133
[    1.065012] ata4.00: ATA-8: ST3000DM001-9YN166, CC4B, max UDMA/133
[    1.235753] ata7.00: ATA-8: ST3000DM001-9YN166, CC4B, max UDMA/133
[    1.727000] ata8.00: ATA-8: ST3000DM001-9YN166, CC4B, max UDMA/133

This is unhelpful.

Also, the dmesg lines are nicely interleaved, making it rather hard to
line up ataN lines with sdX lines.

--Andy
