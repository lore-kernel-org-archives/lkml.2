Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184Ab0D0Jgz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 05:36:55 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63818 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab0D0Jgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 05:36:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=DMWYsvohTduZ63UOdsfzw7u20FeFwZ3bWiyEGsNFAN53zr378hzbIiEZSMJVi1RvFI
         6/H9/l7ITiCoXjM1oVOhB1vrqYwGITS5uk+zaVIbhkQNBOUxrVNdzdkaKwFJAVoO522X
         6v8UfpRMT7AXmDH44T4l8w9RPbUoxOb6TSflQ=
MIME-Version: 1.0
In-Reply-To: <20100427092934.GH27497@kernel.dk>
References: <20100423205518.GB7008@logfs.org> <20100426143253.GB4364@logfs.org>
	 <20100426143803.GM27497@kernel.dk> <20100426144532.GN27497@kernel.dk>
	 <20100426163050.GC4364@logfs.org> <20100426163126.GD4364@logfs.org>
	 <x2v4aa525de1004270201t9f57f49fv1e9cfbb2d886e4ad@mail.gmail.com>
	 <20100427091650.GG27497@kernel.dk>
	 <r2l4aa525de1004270226r40c3dd1ctd09e716f47deca39@mail.gmail.com>
	 <20100427092934.GH27497@kernel.dk>
Date: Tue, 27 Apr 2010 11:36:52 +0200
Message-ID: <n2t4aa525de1004270236mfa841e6bna8adaacc53d599c2@mail.gmail.com>
Subject: Re: [PATCH 2/2] [MTD] Call bdi_init() and bdi_register()
From: Paolo Minazzi <paolo.minazzi@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Just to be on the safe side - without the patch, does it work or not?
>
> --
> Jens Axboe

Without the patch for me means the standard 2.6.34rc5.
In this case :
- enabling logfs I have an oop in fs/write-back.c:157 before kernel calls init.
- disabling logfs I can do normal mount my root /dev/mtdblock1

This is my experience.

Paolo
