Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933105Ab1FBKEm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 06:04:42 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:38407 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932138Ab1FBKEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 06:04:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=WSPpxSn5mUIVZGOpL7dgOsG5op+qxNDSIVRxDcSMor2uEpfKe5C6fYe48D5NZ8gm2x
         R5xB29dl4ehtfY4G32pDeADMSVQBvf15tFZk6ZxMr7XExjAKHlsuYWysVeQXnB1xqKMp
         g3xRP6BFB9rEWu/C8fw7Lj875EOomgmakQErY=
MIME-Version: 1.0
In-Reply-To: <BANLkTikSKyKuseG+iehh=-wfDCu46sinZw@mail.gmail.com>
References: <1306939009-11283-1-git-send-email-akinobu.mita@gmail.com>
	<46950A08-9300-4649-A38D-88829035DFC2@dilger.ca>
	<BANLkTikSKyKuseG+iehh=-wfDCu46sinZw@mail.gmail.com>
Date: Thu, 2 Jun 2011 19:04:40 +0900
Message-ID: <BANLkTi=mdiK7us_b-YKhiu60csQJTcihsw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] ext4: arrange ext4_*_bit() macros
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>, linux-kernel@vger.kernel.org,
        "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        Yongqiang Yang <xiaoqiangnk@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/6/2 Amir Goldstein <amir73il@gmail.com>:
> FYI, one of the snapshot patches (snapshot_exclude_bitmap.patch)
> uses ext4_set_bit_atomic() to set bits in the exclude bitmap when
> moving blocks to snapshot file.
> Since moving blocks is not done in allocation context, there is no
> buddy/group lock held while manipulating the exclude bitmap.
> So I would appreciate if this specific macro will not be removed.
>
> Thanks, Yongqiang , for pointing that out.

OK, I'll keep ext4_*_bit_atomic() in the next version.
