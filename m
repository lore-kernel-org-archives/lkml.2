Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640Ab0L0MJU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 07:09:20 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:42325 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439Ab0L0MJS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 07:09:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=PtMe9r8gKxFgt/JqPDHE2iUovcESOdWEKkLmqrOdXNBTsZIRKh1LsTPiaRwf8yjc/3
         JmqZ+86JjtUgwtI3M0/WakoeCsANeYNVpPb9fvu8F+tCsFOQEixmkhwSAa9rAGv/mBIQ
         gvpdNs7JeeSH0ybMOt0wBkWvQyMGlFYVwDftk=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <AANLkTinVO8Mf4LnSj5fbtpHXHtwc8Wf306XEDgaqH437@mail.gmail.com>
References: <20101227170451.a9a9f873.sfr@canb.auug.org.au>
	<AANLkTikbiART+SX_JwM=pcAg0NJffVgX1oU=aO42dmbC@mail.gmail.com>
	<20101227201155.ee8cd1ab.sfr@canb.auug.org.au>
	<AANLkTinVO8Mf4LnSj5fbtpHXHtwc8Wf306XEDgaqH437@mail.gmail.com>
Date: Mon, 27 Dec 2010 13:09:17 +0100
Message-ID: <AANLkTikDXepvbUEHBCR=W99FY-yuowQs1mYAAYt_xoSh@mail.gmail.com>
Subject: Re: linux-next: Tree for December 27
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 27, 2010 at 10:55 AM, Sedat Dilek
<sedat.dilek@googlemail.com> wrote:
> On Mon, Dec 27, 2010 at 10:11 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> Hi,
>>
>> On Mon, 27 Dec 2010 09:04:06 +0100 Sedat Dilek <sedat.dilek@googlemail.com> wrote:
>>>
>>> Can you try to upload/push via IPADDR?
>>
>> I can only upload to master.kernel.org, the rest is done by the mirroring
>> software.  I have no access to any of the other kernel.org machines.
>>
>
> I was wondering about still "slow mirrors" as also checking out before
> Xmas was very slow.
> Now, seeing from an end-users point, the checking-out is just fine.
> I tried to clone
> "$GIT_MIRROR/pub/scm/linux/kernel/git/npiggin/linux-npiggin.git" where
> GIT_MIRROR was:
>
> 1. git://130.239.17.7
> 2. git://199.6.1.166
> 3. git//git.kernel.org
> 4. git//git.eu.kernel.org
>
> All checkouts had around 680-690KiB/s.
>

DAMN!
The above was with cloning the vfs-tree from Nick Piggin, with
linux-next GIT it is a difference from where you clone (from my
GeoIP-location):

$ git clone git://130.239.17.7/pub/scm/linux/kernel/git/next/linux-next.git
Cloning into linux-next...
remote: Counting objects: 3164616, done.
remote: Compressing objects: 100% (416281/416281), done.
remote: Total 3164616 (delta 2756821), reused 3128824 (delta 2721031)
Receiving objects: 100% (3164616/3164616), 535.89 MiB | 685 KiB/s, done.
Resolving deltas: 100% (2756821/2756821), done.

$ git clone git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
Cloning into linux-next...
remote: Counting objects: 3164616, done.
fatal: The remote end hung up unexpectedly
fatal: early EOF
fatal: index-pack failed

Anyway, it would be great if someone of the resposibles for the
kernel-mirrors would take care of these problems.

- Sedat -
