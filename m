Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933501Ab0EDTn2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 15:43:28 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:55107 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932951Ab0EDTn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 15:43:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=oafAoIdxSbGsSZxktUu8VXPOBltBSOt7fJdtvf9QmAXz7hdblvDV3zXse/929USkrU
         6z9ek+g+ZAqx1hINg6cCdcPFqurdcB9AfK1pqgU1kchxFToqfUpuR2CzZUQIDftjslWN
         J14uaJc2XlqqKzK3Rc/YVS3zhxVdK10bqbh9w=
MIME-Version: 1.0
In-Reply-To: <87mxwfy0fc.fsf@devron.myhome.or.jp>
References: <x2gd4f60c3c1005032259p8be864bcucff91618016a0eb@mail.gmail.com>
	 <20100504103232.GA25054@infradead.org>
	 <t2gd4f60c3c1005041101o5720e1e4k69b4a7b76296e70f@mail.gmail.com>
	 <87mxwfy0fc.fsf@devron.myhome.or.jp>
Date: Tue, 4 May 2010 12:43:25 -0700
Message-ID: <q2od4f60c3c1005041243t233194f7va29ffa8d0de7623f@mail.gmail.com>
Subject: Re: nfs accesses of FAT fs folders causes deadlock on lock_super
From: Fredrick Prashanth John Berchmans <fredrickprashanth@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> As far as I can see, nfsd is buffering the result of readdir, then do
> jobs (encode_fh, etc.) with it on other context of readdir.
>
> Aren't you missing a buffering of nfsd_buffered_readdir()?

Sorry I missed that.
My boxes run 2.6.27 kernel which does not have nfsd_buffered_readdir.

Thanks,
Fredrick
