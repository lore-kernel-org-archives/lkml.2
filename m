Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105Ab2FQWJl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 18:09:41 -0400
Received: from elasmtp-banded.atl.sa.earthlink.net ([209.86.89.70]:53558 "EHLO
	elasmtp-banded.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751943Ab2FQWJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 18:09:39 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=Oi00phmTfaU9GJfW2EljwAx1UM7b7TWWYaHOViIgOQArQuHQM3CTM2NSlcvBIcsV;
  h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Message-ID: <4FDE55A0.50804@earthlink.net>
Date: Sun, 17 Jun 2012 15:09:36 -0700
From: jdow <jdow@earthlink.net>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Martin Steigerwald <Martin@lichtvoll.de>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, linux-m68k@vger.kernel.org
Subject: Re: Partitions: Amiga RDB partition on 2 TB disk way too big, while
 OK in AmigaOS 4.1
References: <201206170841.20222.Martin@lichtvoll.de> <4FDDB667.4020609@earthlink.net> <201206171458.58462.Martin@lichtvoll.de> <CAMuHMdWY7=2nJDUjQFGPhdOAFGYeUsnvgPcaEvB2Gxf7P=E+Ug@mail.gmail.com> <4FDE46E4.7020009@earthlink.net> <CAMuHMdVEq3RrQVJF9RgyC7UH-VAcWK=9FVvOs5Hf9X1gzv8UvQ@mail.gmail.com>
In-Reply-To: <CAMuHMdVEq3RrQVJF9RgyC7UH-VAcWK=9FVvOs5Hf9X1gzv8UvQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: bb89ecdb26a8f9f24d2b10475b571120841c09a80b8d9eb6d8d9ddef9ba97647b3d6b29ebf2fd88f350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 208.127.11.14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2012/06/17 14:15, Geert Uytterhoeven wrote:
> Hi Joanne,
>
> On Sun, Jun 17, 2012 at 11:06 PM, jdow <jdow@earthlink.net> wrote:
>> I've asked Martin for a digital copy of his RDBs and what he thinks the
>> partition(s) should look like. I should also be told whether the disk
>> is supposed to be solely Amiga OSs or not. I gather it's not.
>
> His RDB is attached to https://bugzilla.kernel.org/show_bug.cgi?id=43521


I want the raw binary on the blocks 0 through the end of the RDBs or
128 blocks, which ever comes first. I don't see that there. I just
see the amiga-fdisk printout of it. With the actual binary I can
parse it myself and see what comes out.

(As a side note - RDBs work with large sector sizes. They pretty much
always have.)


...

>
> Gr{oetje,eeting}s,
>
>                          Geert

{^_^}
