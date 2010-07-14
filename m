Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565Ab0GNCjk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 22:39:40 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45001 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756473Ab0GNCji convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 22:39:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=oLql/Ro4s4krZ9GSUIS4P4YmUJRFW+NyLXQSzVbNmeX32A5CH483xaSZPv0Qtsmhrm
         lSu4nBxORh0xagS1q3wHWNRmmFVu/XBxRpmjEOYGs2QxwEMAw45OUTt/zdVklTTw2qgj
         XROd/NMulx8NyVN1FPcspQszjhjVG39ulPzYg=
MIME-Version: 1.0
In-Reply-To: <4C3BEBC4.6000902@redhat.com>
References: <AANLkTin1uF6WbVvxJ84oO1NKnCU-6VHrmWU1XFYTlqtp@mail.gmail.com>
	<4C3BEBC4.6000902@redhat.com>
Date: Wed, 14 Jul 2010 04:39:35 +0200
Message-ID: <AANLkTikXpAxDvb-tm7Aq8y96ceCs3CKXmKTl-DidojD6@mail.gmail.com>
Subject: Re: BTRFS: Unbelievably slow with kvm/qemu
From: Giangiacomo Mariotti <gg.mariotti@gmail.com>
To: Avi Kivity <avi@redhat.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 13, 2010 at 6:29 AM, Avi Kivity <avi@redhat.com> wrote:
> Btrfs is very slow on sync writes:
>
> 45KB/s, while 4-5MB/s traffic was actually going to the disk.  For every 4KB
> that the the application writes, 400KB+ of metadata is written.
>
> (It's actually worse, since it starts faster than the average and ends up
> slower than the average).
>
> For kvm, you can try cache=writeback or cache=unsafe and get better
> performance (though still slower than ext*).
>
Yeah, well I've already moved the virtual hd file to an ext3
partition, so the problem for me was actually already "solved" before
posting the first post. I posted the first message just to report the
particularly bad performances of Btrfs for this test-case, so that, if
not already known, they could be investigated and hopefully solved.

By the way, thanks to everyone who answered!

-- 
Giangiacomo
