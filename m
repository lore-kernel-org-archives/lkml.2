Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932147Ab0LRTOF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 14:14:05 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:56882 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757145Ab0LRTOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 14:14:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=rMTisTSiBY/DtwjVkNcn9j595JKxIcj5OKiC6Bem/JIaPe3rHo6D4BtCrk6qo03eK1
         w2Aw5CrXm3XPsrpIk6AK39wHbGQMqrQaGDs2msKD0uXLQh3xOLeooR9nR0PeZvJGpmF1
         GR2qSYlGp02VtyZRAZsHuXQA9R5vjAnttDIgM=
MIME-Version: 1.0
In-Reply-To: <4D0BD79B.2010600@vlnb.net>
References: <1292557664.31461.68.camel@haakon2.linux-iscsi.org>
	<1292599364.2820.21.camel@mulgrave.site>
	<4D0B8975.1040206@vlnb.net>
	<1292602908.2820.41.camel@mulgrave.site>
	<4D0BBE40.6030000@vlnb.net>
	<1292617658.2820.80.camel@mulgrave.site>
	<4D0BD79B.2010600@vlnb.net>
Date: Sat, 18 Dec 2010 14:13:59 -0500
Message-ID: <AANLkTimV-evsF4MFXs6JQ5H55AgtOpGrTuCdJBx9O_P=@mail.gmail.com>
Subject: Re: [ANNOUNCE] TCM/LIO v4.0.0-rc6 for 2.6.37-rc6
From: chetan loke <loke.chetan@gmail.com>
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: James Bottomley <James.Bottomley@suse.de>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>,
        "Patil, Kiran" <kiran.patil@intel.com>,
        Mike Christie <michaelc@cs.wisc.edu>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Hannes Reinecke <hare@suse.de>, Boaz Harrosh <bharrosh@panasas.com>,
        Joe Eykholt <jeykholt@cisco.com>, "J.H." <warthog9@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Bart Van Assche <bart.vanassche@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 17, 2010 at 4:35 PM, Vladislav Bolkhovitin <vst@vlnb.net> wrote:
>
> In this regard it looks to be a good idea to freeze accepting both LIO
> and SCST until the end of the next year and then choose one with the
> biggest activity in the related mailing lists, not counting me and
> NicholasB.
>

Why wait till the end of the next year? What I proposed earlier was
'to review at the architecture level'. If folks don't agree to it then
this email drama will never
stop. Once the review starts we can decide on a common baseline to
benchmark both the stacks. I'm more than willing to test/benchmark
ESX(front-end)/SCST/LIO(back-end) combo. I'm sure there will be others
who would be willing to spend some of their time for this cause to
validate claims made by both the communities. We can then publish all
the results so that others can reproduce them.

> You want the best community, so let community choose!
>

Sure, and then we will let community choose what's best for them. And
if that means picking the best from both the worlds and coming up w/ a
unified stack then that's great!

> Vlad
> --
Chetan
