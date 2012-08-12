Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104Ab2HLQug (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 12:50:36 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:46785 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751873Ab2HLQuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 12:50:35 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av8EAFLeJ1B5LUgY/2dsb2JhbABEuXmBCIIhAQUnER4iARAIAw4TFAIPCQMCAQIBJx4GDQEHAogIDLhGixKGMQOITI4TiBiGZIJv
Message-ID: <5027DED7.3050606@internode.on.net>
Date: Mon, 13 Aug 2012 02:20:31 +0930
From: Arthur Marsh <arthur.marsh@internode.on.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.6esrpre) Gecko/20120805 Icedove/10.0.6
MIME-Version: 1.0
To: Josh Boyer <jwboyer@gmail.com>
CC: miklos@szeredi.hu, viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: fuse: implement i_op->atomic_open() prevents writes to ntfs-3g
 filesystem
References: <5027B6B2.70204@internode.on.net> <CA+5PVA6B7aOnsH6w=4vixe2c9OgR5gvKB+QaQ-Tpy-7rw-tqeQ@mail.gmail.com>
In-Reply-To: <CA+5PVA6B7aOnsH6w=4vixe2c9OgR5gvKB+QaQ-Tpy-7rw-tqeQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Josh Boyer wrote, on 13/08/12 00:07:
> On Sun, Aug 12, 2012 at 9:59 AM, Arthur Marsh
...
>> Has this problem been seen by anyone else?
>
> Yep, it was reported in Fedora last week.
>
>> Is a fix already in the works?
>
> Miklos posted this patch series that fixed things:
>
> http://thread.gmane.org/gmane.linux.file-systems/66445/focus=1339000
>
> josh
>

Thanks, after applying these 4 patches to the current Linus git head, 
the resulting kernel has no problems creating files with ntfs-3g.

Arthur.

