Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427Ab0JWRbX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 13:31:23 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37350 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386Ab0JWRbW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 13:31:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=aClkoxGO6IKtpkpFC/FVsp7K5BgWp9uONmxktwj7fzkAT/zPgARrSGVn7fR9+1cQ/i
         wfYRb1jC68+p9g4/KgYCHM039YRYfKgoRVhI29IkuhupkRwC8ruUl+bsbCt4J+29k+N4
         0cc/R5jYfhdXwoWrmJDQvIig9U0WYVuYiChXY=
MIME-Version: 1.0
In-Reply-To: <4C976060.1010008@kernel.dk>
References: <201007202209.04627.czoccolo@gmail.com>
	<AANLkTinajj76EBUQE6RXeQmZ9AEWU1g3x+pyW3Cmku0x@mail.gmail.com>
	<4C976060.1010008@kernel.dk>
Date: Sat, 23 Oct 2010 19:31:21 +0200
Message-ID: <AANLkTi=VZ0-ysHZ1oqK6b0DsohgD8G65UY=_tUfyK7bh@mail.gmail.com>
Subject: Re: [PATCH] cfq: improve fsync performance for small files
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
        Jeff Moyer <jmoyer@redhat.com>, Vivek Goyal <vgoyal@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,
I've not seen this patch in your pull request to Linus for .37.
Any problem with it during test?

Thanks
Corrado

On Mon, Sep 20, 2010 at 3:23 PM, Jens Axboe <axboe@kernel.dk> wrote:
>
> On 2010-09-12 16:40, Corrado Zoccolo wrote:
> > Hi Jens,
> > any comment on this patch, or the problem we are trying to solve?
>
> I have queued it up for .37.
>
> --
> Jens Axboe
>



--
__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------
The self-confidence of a warrior is not the self-confidence of the average
man. The average man seeks certainty in the eyes of the onlooker and calls
that self-confidence. The warrior seeks impeccability in his own eyes and
calls that humbleness.
                               Tales of Power - C. Castaneda
