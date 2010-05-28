Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932748Ab0E1KGk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 06:06:40 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:57160 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758318Ab0E1KGi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 06:06:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=jW54XDpRpU9GYZdpYm59u4WztNvTpY3A82CiW7rEHFO+eKoIJ6yQa3FPkRAhVqImCl
         C5anB/JGDBJZSW2G7mrUA0+OZJq7ZRiPjaI4jnn/YKvm55thWIs6tPG+rUH4HtFH6SBH
         AzB/zVHjfMmyFYVD9UdMTp6S6FCD2fY0ex3eo=
MIME-Version: 1.0
In-Reply-To: <E1OHw3d-0001yr-Ag@pomaz-ex.szeredi.hu>
References: <1274885054-15698-1-git-send-email-xiaosuo@gmail.com> 
	<E1OHw3d-0001yr-Ag@pomaz-ex.szeredi.hu>
From: Changli Gao <xiaosuo@gmail.com>
Date: Fri, 28 May 2010 18:06:18 +0800
Message-ID: <AANLkTimzsHAxha3vQxeFn5pF5BmYZ8nLawSG2YU3eujZ@mail.gmail.com>
Subject: Re: [PATCH v2 3/4]: sendfile: remove flags paramter of 
	do_splice_direct()
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: axboe@kernel.dk, viro@zeniv.linux.org.uk, matthew@wil.cx, mszeredi@suse.cz,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 28, 2010 at 5:40 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Wed, 26 May 2010, Changli Gao wrote:
>> remove flags paramter of do_splice_direct().
>>
>> the flags parameter of do_splice_direct() doesn't mean non-block read of
>> in file,
>
> Actually, it does.  Look at the SPLICE_F_NONBLOCK usage in
> __generic_splice_file_read().
>

Oh, I checked the code again. You're right. However, why don't we
check the flags of in file instead in __generic_file_splice_read()?

-- 
Regards，
Changli Gao(xiaosuo@gmail.com)
