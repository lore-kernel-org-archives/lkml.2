Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368Ab0ELAEX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 20:04:23 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43432 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733Ab0ELAEV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 20:04:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=T6+s6CQxQ68I2OWtlWI/mWCqSUw+Cg2CGi+LjpUwOLL5RI1I2OJif0CnEQO3cbaqya
         1RlW6EF9xmPTDai7azLrv/NDUcU/00qNQ85xV9UVSlmnYfiDGv1O210S/odOAyE6nR9L
         yetERBQ4zOBZKYNVMUQyZEkPQIPaZzHwklNEs=
MIME-Version: 1.0
In-Reply-To: <20100511230901.GA31325@fluff.org.uk>
References: <1273403087-3326-1-git-send-email-vapier@gentoo.org> 
	<1273505624-30920-1-git-send-email-vapier@gentoo.org> <20100511230901.GA31325@fluff.org.uk>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 11 May 2010 20:03:57 -0400
Message-ID: <AANLkTilE253KvDpOGpXpxIyjqDd8Z7Uffa4JaUNneXYs@mail.gmail.com>
Subject: Re: [PATCH v2] i2c-bfin-twi: handle faulty slave devices better
To: Ben Dooks <ben-linux@fluff.org>
Cc: linux-i2c@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Michael Hennerich <michael.hennerich@analog.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 11, 2010 at 19:09, Ben Dooks wrote:
> On Mon, May 10, 2010 at 11:33:44AM -0400, Mike Frysinger wrote:
>> From: Michael Hennerich <michael.hennerich@analog.com>
>>
>> Faulty slave devices might drive SDA low after a transfer finishes.  So,
>> when this scenario is detected, have the master generate up to 9 extra
>> clocks until the SDA is properly released.
>
> This doesn't apply to my for-2635/i2c-bfin tree, can't find the BUFWERR
> patch. will check to see if theres's something i've missed..

have you applied the other Blackfin I2C patches yet ?  the bfin i2c
branch applies cleanly to linus' current tree:
  git://git.kernel.org/pub/scm/linux/kernel/git/vapier/blackfin.git for-i2c
-mike
