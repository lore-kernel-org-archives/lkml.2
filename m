Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757700Ab2FQW2A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 18:28:00 -0400
Received: from elasmtp-banded.atl.sa.earthlink.net ([209.86.89.70]:36147 "EHLO
	elasmtp-banded.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753259Ab2FQW15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 18:27:57 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=pCb2Oq8H1lAA7MFd2NqjQAAbuD6Ix+6MaRHszBnKUh/RXMN6VWkcJWVm5f8DMJVS;
  h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Message-ID: <4FDE59EB.8050305@earthlink.net>
Date: Sun, 17 Jun 2012 15:27:55 -0700
From: jdow <jdow@earthlink.net>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Martin Steigerwald <Martin@lichtvoll.de>
CC: Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, linux-m68k@vger.kernel.org
Subject: Re: Partitions: Amiga RDB partition on 2 TB disk way too big, while
 OK in AmigaOS 4.1
References: <201206170841.20222.Martin@lichtvoll.de> <201206171458.58462.Martin@lichtvoll.de> <CAMuHMdWY7=2nJDUjQFGPhdOAFGYeUsnvgPcaEvB2Gxf7P=E+Ug@mail.gmail.com> (sfid-20120617_225443_752860_DC66624F) <201206172306.03202.Martin@lichtvoll.de>
In-Reply-To: <201206172306.03202.Martin@lichtvoll.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: bb89ecdb26a8f9f24d2b10475b571120841c09a80b8d9eb6a7dd2b2e0e144fada0e5cba465e57921350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 208.127.11.14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012/06/17 14:06, Martin Steigerwald wrote:
...

I have a usage note for you and the person who did that partitioning.
If you start the partition at block 1 instead of block zero it probably
can coexist nicely with normal fdisk partitioning as well. (It used to
be able to since x86 partition tables didn't bother with blocks on the
first "cylinder" other than block zero.) I designed RDPrepX and
HDWrench to take advantage of that. (And I used it myself. Erm I used a
LOT of abominations such as safely nested partitions.)

{^_^}
